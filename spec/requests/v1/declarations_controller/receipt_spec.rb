require 'rails_helper'

describe V1::DeclarationsController do
  describe 'GET /declarations/:id/receipt', version: 1 do
    let(:record) { create(:declaration, :with_receipt) }
    let(:record_url) { "/v1/declarations/#{record.id}/receipt" }
    let(:record_permission) { 'declaration.read' }

    it_behaves_like 'a permissible model'

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      let(:request) { get(record_url) }

      it_behaves_like '200 OK'
      it { expect(request.media_type).to eq 'image/jpeg' }

      context 'when the declaration has no receipt' do
        let(:record) { create(:declaration) }

        it_behaves_like '404 Not Found'
      end
    end
  end
end
