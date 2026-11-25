require 'rails_helper'

describe V1::DeclarationsController do
  describe 'POST /declarations/:id/reject', version: 1 do
    let(:record) { create(:declaration) }
    let(:record_url) { "/v1/declarations/#{record.id}/reject" }
    let(:rejection_reason) { 'Geen zakelijke uitgave' }
    let(:request) { post(record_url, rejection_reason:) }

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
      it { expect { request }.to(change { record.reload.status }.to('rejected')) }
      it { expect { request }.to(change { record.reload.rejection_reason }.to(rejection_reason)) }
      it { expect { request }.to have_enqueued_mail(DeclarationMailer, :rejected_email) }

      context 'when without a reason' do
        let(:rejection_reason) { nil }

        it_behaves_like '422 Unprocessable Content'
      end

      context 'when the declaration is already approved' do
        let(:record) { create(:declaration, :approved) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
