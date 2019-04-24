require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/:id', version: 1 do
    let(:record) { FactoryBot.build(:user) }
    let(:record_url) { '/v1/users' }
    let(:record_permission) { 'user.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_attributes) { record.attributes }
      let(:invalid_attributes) { { email: 'jan_without_domain' } }
    end

    describe 'when a user is created' do
      subject(:request) do
        perform_enqueued_jobs do
          post(record_url,
               data: {
                 id: record.id,
                 type: record_type(record),
                 attributes: record.attributes
               })
        end
      end

      context 'when authenticated' do
        include_context 'when authenticated' do
          let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
        end

        context 'when the user is login_enabled' do
          let(:record) do
            FactoryBot.build(:user, first_name: 'jan',
                                    last_name_prefix: 'de',
                                    last_name: 'vries',
                                    login_enabled: true)
          end
          let(:email) { ActionMailer::Base.deliveries.last }

          before { request }

          it 'sets the right activation token valid time' do
            user = User.find(json['data']['id'])
            expect(user.activation_token_valid_till).to be_within(10.seconds).of(1.day.from_now)
          end

          it 'sends an email to the correct email address' do
            user = User.find(json['data']['id'])
            expect(email.to[0]).to eq user.email
          end

          it 'sends an email with valid activation token' do
            user = User.find(json['data']['id'])
            expect(email.body.to_s).to include user.activation_token
          end

          it 'sends an email that includes username' do
            user = User.find(json['data']['id'])
            expect(email.body.to_s).to include user.username
          end

          it 'sets the right username' do
            user = User.find(json['data']['id'])
            expect(user.username).to eq 'jan.devries'
          end
        end

        context 'when the user is not login_enabled' do
          let(:record) do
            FactoryBot.build(:user, first_name: 'jan',
                                    last_name_prefix: 'de',
                                    last_name: 'vries',
                                    login_enabled: false)
          end
          let(:email) { ActionMailer::Base.deliveries.last }

          before { request }

          it 'does not send an email' do
            expect(email).to eq nil
          end
        end
      end
    end
  end
end
