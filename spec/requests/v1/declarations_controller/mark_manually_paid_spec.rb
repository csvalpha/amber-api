require 'rails_helper'

describe V1::DeclarationsController do
  describe 'POST /declarations/:id/mark_manually_paid', version: 1 do
    let(:record) { create(:declaration, :approved) }
    let(:record_url) { "/v1/declarations/#{record.id}/mark_manually_paid" }
    let(:request) { post(record_url) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      it_behaves_like '403 Forbidden'
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: ['declaration.update']) }
      end

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.reload.status }.to('paid')) }
      it { expect { request }.to(change { record.reload.manually_paid_by }.to(user)) }

      context 'when the declaration is pending' do
        let(:record) { create(:declaration) }

        it_behaves_like '403 Forbidden'
      end

      context 'when the declaration is already paid' do
        let(:record) { create(:declaration, :approved, status: :paid) }

        it_behaves_like '403 Forbidden'
      end

      context 'when the declaration can not be saved' do
        before do
          record.update_column(:description, '') # rubocop:disable Rails/SkipsModelValidations
        end

        it_behaves_like '422 Unprocessable Content'
      end
    end
  end
end
