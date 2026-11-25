require 'rails_helper'

describe V1::DeclarationsController do
  describe 'PUT /declarations/:id', version: 1 do
    let(:record) { create(:declaration) }
    let(:record_url) { "/v1/declarations/#{record.id}" }
    let(:attributes) { { description: 'Nieuwe omschrijving' } }
    let(:request) { put(record_url, data: { id: record.id, type: 'declarations', attributes: }) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated as another user' do
      include_context 'when authenticated'

      it_behaves_like '403 Forbidden'
    end

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      it_behaves_like '200 OK'
      it { expect { request }.to(change { record.reload.description }.to('Nieuwe omschrijving')) }

      context 'when the declaration is approved' do
        let(:record) { create(:declaration, :approved) }

        it_behaves_like '403 Forbidden'
      end

      context 'when setting include in next collection' do
        let(:attributes) { { include_in_next_collection: true } }

        it { expect { request }.not_to(change { record.reload.include_in_next_collection }) }
      end
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: ['declaration.update']) }
      end

      context 'when the declaration is approved' do
        let(:record) { create(:declaration, :approved) }

        before { record }

        it_behaves_like '200 OK'
        it { expect { request }.to have_enqueued_job(DeclarationPdfJob) }
      end

      context 'when toggling include in next collection' do
        let(:record) { create(:declaration, :approved) }
        let(:attributes) { { include_in_next_collection: false } }

        it_behaves_like '200 OK'
        it { expect { request }.to(change { record.reload.include_in_next_collection }.to(false)) }
      end

      context 'when the declaration is partially paid' do
        let(:record) { create(:declaration, :approved, status: :partially_paid) }

        it_behaves_like '422 Unprocessable Content'

        context 'when only toggling include in next collection' do
          let(:attributes) { { include_in_next_collection: false } }

          it_behaves_like '200 OK'
        end
      end

      context 'when the declaration is paid' do
        let(:record) { create(:declaration, :approved, status: :paid) }
        let(:attributes) { { include_in_next_collection: false } }

        it_behaves_like '403 Forbidden'
      end

      context 'when the declaration is rejected' do
        let(:record) { create(:declaration, :rejected) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
