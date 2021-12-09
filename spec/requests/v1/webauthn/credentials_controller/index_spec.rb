require 'rails_helper'

describe V1::Webauthn::CredentialsController do
  describe 'GET /webauthn/credentials', version: 1 do
    let(:records) { FactoryBot.create_list(:credential, 3) }
    let(:record_url) { '/v1/webauthn/credentials' }
    let(:request) { get(record_url) }

    context 'when without permission' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      before { records }

      include_context 'when authenticated' do
        let(:user) { records.last.user }
      end

      it_behaves_like '200 OK'
      # We can only see our own credential
      it { expect(json['data'].count).to eq 1 }
    end
  end
end
