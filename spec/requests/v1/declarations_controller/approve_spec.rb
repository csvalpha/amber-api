require 'rails_helper'

describe V1::DeclarationsController do
  describe 'POST /declarations/:id/approve', version: 1 do
    let(:record) { create(:declaration) }
    let(:record_url) { "/v1/declarations/#{record.id}/approve" }
    let(:request) { post(record_url) }

    before { create(:mandate, user: record.user) }

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
      it { expect { request }.to(change { record.reload.status }.to('approved')) }
      it { expect { request }.to have_enqueued_mail(DeclarationMailer, :approved_email) }
      it { expect { request }.to have_enqueued_job(DeclarationPdfJob) }

      context 'when on a non existing declaration' do
        let(:record_url) { "/v1/declarations/#{record.id + 1}/approve" }

        it_behaves_like '404 Not Found'
      end

      context 'when the declaration is already approved' do
        let(:record) { create(:declaration, :approved) }

        it_behaves_like '403 Forbidden'
      end

      context 'when the user has no active mandate' do
        before { record.user.mandates.delete_all }

        it_behaves_like '422 Unprocessable Content'
        it { expect { request }.not_to have_enqueued_mail(DeclarationMailer, :approved_email) }
      end
    end
  end
end
