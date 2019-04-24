require 'rails_helper'

describe V1::OAuthAuthorizationsController do
  describe 'GET /v1/oauth/authorize' do
    let(:my_app) do
      Doorkeeper::Application.create(name: 'MyApp', redirect_uri: 'https://testhost:1338/users/auth/amber_oauth2/callback')
    end

    let(:request_url) { '/v1/oauth/authorize' }
    let(:default_options) { Rails.application.config.action_mailer.default_url_options }
    let(:target_redirect_url) do
      URI::Generic.build(default_options).merge(
        "/oauth/authorize?client_id=#{my_app.uid}&redirect_uri=#{CGI.escape(my_app.redirect_uri)}"
      ).to_s
    end

    describe 'when accessing authorize' do
      subject(:request) do
        get(request_url,
            client_id: my_app.uid,
            redirect_uri: my_app.redirect_uri)
      end

      it { expect(request.status).to eq 302 }
      it { expect(request.header['Location']).to eq target_redirect_url }
    end
  end
end
