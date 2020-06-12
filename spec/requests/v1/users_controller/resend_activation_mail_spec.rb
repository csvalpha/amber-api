require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/:id/resend_activation_mail', version: 1 do
    let(:activation_token) { Faker::Crypto.sha256 }
    let(:record_url) { "/v1/users/#{record.id}/resend_activation_mail" }

    context 'when without authentication' do
      let(:record) { FactoryBot.create(:user) }

      subject(:request) { post(record_url) }

      it_behaves_like '401 Unauthorized'
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: ['user.create']) }
      end

      context 'when with activated user' do
        let(:record) do
          FactoryBot.create(:user, activated_at: Faker::Time.between(from: 1.month.ago,
                                                                     to: Date.yesterday))
        end
        let(:email) { ActionMailer::Base.deliveries }

        subject(:request) { post(record_url) }

        before { request }

        it_behaves_like '404 Not Found'

        it 'sends no email' do
          expect(email.count).to eq 0
        end
      end

      context 'when with unactivated user' do
        let(:record) { FactoryBot.create(:user) }
        let(:email) { ActionMailer::Base.deliveries.last }

        subject(:request) { perform_enqueued_jobs { post(record_url) } }

        before { request && record.reload }

        it_behaves_like '204 No Content'

        it do
          expect(record.activation_token_valid_till).to be_within(10.seconds).of(1.day.from_now)
        end

        it { expect(email.to[0]).to eq record.email }
        it { expect(email.body.to_s).to include record.activation_token }
        it { expect(email.body.to_s).to include record.username }
      end
    end
  end
end
