require 'rails_helper'

describe V1::DeclarationsController do
  describe 'DELETE /declarations/:id', version: 1 do
    let(:record) { create(:declaration) }
    let(:record_url) { "/v1/declarations/#{record.id}" }
    let(:record_permission) { 'declaration.destroy' }

    it_behaves_like 'a destroyable and permissible model'

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      let(:request) { delete(record_url) }

      it_behaves_like '204 No Content'
      it { expect { request }.not_to have_enqueued_mail(DeclarationMailer, :deleted_email) }

      context 'when the declaration is approved' do
        let(:record) { create(:declaration, :approved) }

        it_behaves_like '403 Forbidden'
      end
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      let(:request) { delete(record_url) }

      it { expect { request }.to have_enqueued_mail(DeclarationMailer, :deleted_email) }

      context 'when the declaration is approved' do
        let(:record) { create(:declaration, :approved) }

        it_behaves_like '204 No Content'
      end

      context 'when the declaration is (partially) paid' do
        let(:record) { create(:declaration, :approved, status: :partially_paid) }

        it_behaves_like '403 Forbidden'
      end

      context 'when an approved declaration already has a settlement' do
        let(:record) { create(:declaration, :approved) }

        before { create(:transaction, declaration: record, user: record.user, amount: -1) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
