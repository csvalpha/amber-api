require 'rails_helper'

describe Doorkeeper::TokensController do
  describe 'POST /v1/oauth/token' do
    let(:user) do
      FactoryBot.create(
        :user,
        username: 'bestuur',
        password: 'password1234',
        password_confirmation: 'password1234',
        login_enabled: true,
        activated_at: Time.zone.now
      )
    end

    let(:public_application) { FactoryBot.create(:application, confidential: false) }
    let(:application) { FactoryBot.create(:application) }
    let(:request_url) { '/v1/oauth/token' }

    before { user }

    describe 'when logging in with public client' do
      subject(:request) do
        post(request_url,
             client_id: public_application.uid,
             grant_type: 'password',
             username: 'bestuur',
             password: 'password1234')
      end

      it_behaves_like '200 OK'
    end

    describe 'when logging in with non existing client' do
      subject(:request) do
        post(request_url,
             client_id: 'non_existing_client',
             grant_type: 'password',
             username: 'bestuur',
             password: 'password1234')
      end

      it_behaves_like '401 Unauthorized'
    end

    describe 'when logging in with incorrect client_secret' do
      subject(:request) do
        post(request_url,
             client_id: application.uid,
             client_secret: 'incorrect_secret',
             grant_type: 'password',
             username: 'bestuur',
             password: 'password1234')
      end

      it_behaves_like '401 Unauthorized'
    end

    describe 'when logging in with correct credentials' do
      subject(:request) do
        post(request_url,
             client_id: application.uid,
             client_secret: application.plaintext_secret,
             grant_type: 'password',
             username: 'bestuur',
             password: 'password1234')
      end

      it_behaves_like '200 OK'

      describe 'when user is not login_enabled' do
        before { user.update(login_enabled: false) }

        it_behaves_like '400 Bad Request'
      end

      describe 'when user is not activated' do
        before { user.update(activated_at: nil) }

        it_behaves_like '400 Bad Request'
      end

      describe 'when user is not yet activated' do
        before { user.update(activated_at: Time.zone.now.tomorrow) }

        it_behaves_like '400 Bad Request'
      end

      describe 'when user has OTP required' do
        before { user.update(otp_required: true) }

        it_behaves_like '400 Bad Request'
        it { expect(request.headers['X-Amber-OTP']).to eq 'required' }

        describe 'with correct OTP code' do
          before { header('X-Amber-OTP', user.otp_code) }

          it_behaves_like '200 OK'
        end

        describe 'with incorrect OTP code' do
          before { header('X-Amber-OTP', (user.otp_code.to_i + 1).to_s) }

          it_behaves_like '400 Bad Request'
          it { expect(request.headers['X-Amber-OTP']).to eq 'invalid' }
        end
      end
    end

    describe 'when logging in with incorrect password' do
      subject(:request) do
        post(request_url,
             client_id: application.uid,
             client_secret: application.plaintext_secret,
             grant_type: 'password',
             username: 'bestuur',
             password: 'another_password')
      end

      it_behaves_like '400 Bad Request'
    end

    describe 'when logging in with non existing user' do
      subject(:request) do
        post(request_url,
             client_id: application.uid,
             client_secret: application.plaintext_secret,
             grant_type: 'password',
             username: 'non_existing_user',
             password: 'password1234')
      end

      it_behaves_like '400 Bad Request'
    end
  end
end
