require 'rails_helper'

describe V1::DeclarationsController do
  describe 'GET /declarations/:id/pdf', version: 1 do
    let(:record) { create(:declaration, :approved) }
    let(:record_url) { "/v1/declarations/#{record.id}/pdf" }
    let(:record_permission) { 'declaration.read' }

    it_behaves_like 'a permissible model'

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      let(:request) { get(record_url) }

      it_behaves_like '200 OK'
      it { expect(request.media_type).to eq 'application/pdf' }
      it { expect(request.body).to start_with '%PDF' }
      it { expect(request.headers['Content-Disposition']).to include "id#{record.id}.pdf" }

      context 'when the declaration is not approved' do
        let(:record) { create(:declaration) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
