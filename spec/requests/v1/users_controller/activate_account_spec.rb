require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/:id/activate_account', version: 1 do
    let(:activation_token) { Faker::Crypto.sha256 }
    let(:record) do
      FactoryBot.create(:user, login_enabled: true,
                               activation_token: activation_token,
                               activation_token_valid_till: 1.hour.from_now)
    end
    let(:record_url) { "/v1/users/#{record.id}/activate_account" }
    let(:valid_password) { Faker::Internet.password(min_length: 12) }
    let(:params) { { activationToken: activation_token, password: valid_password } }

    subject(:request) { post(record_url, params) }

    context 'when without parameters' do
      let(:params) {}

      it_behaves_like '404 Not Found'
    end

    context 'when with invalid token' do
      before { params.merge!(activationToken: 'invalid_token') }

      it_behaves_like '404 Not Found'
    end

    context 'when activation token has expired' do
      let(:record) do
        FactoryBot.create(:user, login_enabled: true,
                                 activation_token: activation_token,
                                 activation_token_valid_till: 1.second.ago)
      end

      before { request }

      it_behaves_like '404 Not Found'
    end

    context 'when with correct activation token' do
      before { request && record.reload }

      it_behaves_like '204 No Content'

      it 'sets password correctly' do
        expect(record.authenticate(valid_password)).to eq record
      end
    end
  end
end
