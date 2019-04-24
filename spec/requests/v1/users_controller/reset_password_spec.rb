require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/reset_password', version: 1 do
    let(:record) { FactoryBot.create(:user, login_enabled: true) }
    let(:record_url) { '/v1/users/reset_password' }
    let(:params) { { email: record.email } }

    subject(:request) { perform_enqueued_jobs { post(record_url, params) } }

    context 'when without parameters' do
      let(:params) {}

      it_behaves_like '204 No Content'
      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
    end

    context 'when with unknown email' do
      before { params.merge!(email: 'noreply@example.org') }

      it_behaves_like '204 No Content'
      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
    end

    context 'when with inactive user' do
      let(:record) { FactoryBot.create(:user, login_enabled: false) }

      it_behaves_like '204 No Content'
      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
    end

    context 'when with existing email' do
      before { request && record.reload }

      it_behaves_like '204 No Content'

      it { expect(record.activation_token_valid_till).to be_within(10.seconds).of(1.day.from_now) }

      it 'sends an email to correct email address' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to[0]).to eq record.email
      end

      it 'sends an email that includes activation token' do
        email = ActionMailer::Base.deliveries.last
        expect(email.body.to_s).to include record.activation_token
      end

      it 'sends an email that includes username' do
        email = ActionMailer::Base.deliveries.last
        expect(email.body.to_s).to include record.username
      end
    end
  end
end
