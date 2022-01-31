require 'rails_helper'

describe V1::UsersController do
  describe 'GET /users/:id/generate_otp_secret', version: 1 do
    let(:record) { create(:user) }
    let(:record_url) { "/v1/users/#{record.id}/generate_otp_secret" }

    subject(:request) { post(record_url) }

    it_behaves_like '401 Unauthorized'

    context 'when authenticated' do
      include_context 'when authenticated'
      it_behaves_like '403 Forbidden'

      context 'when requesting as user itself' do
        include_context 'when authenticated' do
          let(:user) { record }
        end

        it { expect { request && user.reload }.to(change(user, :otp_secret_key)) }

        describe 'when already requiring OTP' do
          let(:record) { create(:user, otp_required: true) }

          it_behaves_like '422 Unprocessable Entity'
        end
      end
    end
  end
end
