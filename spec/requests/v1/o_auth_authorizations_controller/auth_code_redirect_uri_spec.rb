require 'rails_helper'

describe V1::OAuthAuthorizationsController do
  describe 'GET /oauth/auth_code_redirect_uri', version: 1 do
    let(:my_app) do
      Doorkeeper::Application.create(name: 'MyApp', redirect_uri: 'https://testhost:1338/users/auth/amber_oauth2/callback')
    end

    let(:request_url) { '/v1/oauth/auth_code_redirect_uri' }

    describe 'when authorizing app' do
      subject(:request) do
        post(request_url,
             client_id: my_app.uid,
             redirect_uri: my_app.redirect_uri,
             response_type: 'code',
             state: my_app.secret)
      end

      context 'when not authenticated' do
        it_behaves_like '401 Unauthorized'
      end

      context 'when authenticated' do
        include_context 'when authenticated'

        it_behaves_like '200 OK'
      end
    end
  end
end
