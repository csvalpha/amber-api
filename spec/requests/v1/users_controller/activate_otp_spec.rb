require 'rails_helper'

describe V1::UsersController do
  describe 'GET /users/:id/activate_otp', version: 1 do
    let(:record) { create(:user) }
    let(:record_url) { "/v1/users/#{record.id}/activate_otp" }

    subject(:request) { post(record_url, one_time_password: record.otp_code) }

    it_behaves_like '401 Unauthorized'

    context 'when authenticated' do
      include_context 'when authenticated'
      it_behaves_like '403 Forbidden'

      context 'when requesting as user itself' do
        include_context 'when authenticated' do
          let(:user) { record }
        end

        it { expect { request && user.reload }.to(change(user, :otp_required?)) }

        context 'when providing incorrect OTP code' do
          subject(:request) { post(record_url, one_time_password: (user.otp_code.to_i + 1).to_s) }

          it_behaves_like '422 Unprocessable Entity'
          it { expect { request && user.reload }.not_to(change(user, :otp_required?)) }
        end
      end
    end
  end
end
