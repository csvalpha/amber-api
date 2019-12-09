require 'rails_helper'

describe V1::UsersController do
  describe 'PUT /users/:id', version: 1 do
    let(:record) { FactoryBot.create(:user) }
    let(:record_url) { "/v1/users/#{record.id}" }
    let(:record_permission) { 'user.update' }

    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:invalid_attributes) { { email: '' } }
    end

    describe 'model is conditionally updatable' do
      include_context 'when authenticated' do
        let(:user) { record }
      end

      unrestricted_attributes = %i[email address postcode city phone_number
                                   food_preferences study start_study vegetarian
                                   otp_required picture_publication_preference
                                   info_in_almanak almanak_subscription_preference
                                   digtus_subscription_preference emergency_contact
                                   emergency_number ifes_data_sharing_preference
                                   user_details_sharing_preference]
      permissible_attributes = %i[first_name last_name_prefix last_name birthday]

      it_behaves_like 'a model with conditionally updatable attributes',
                      unrestricted_attributes, permissible_attributes, :ok do
        let(:override_attrs) do
          { last_name_prefix: '_',
            picture_publication_preference: 'always_ask',
            almanak_subscription_preference: 'digital',
            digtus_subscription_preference: 'digital',
            user_details_sharing_preference: 'members_only',
            phone_number: '+31612345678',
            emergency_number: '+31612345678' }
        end
        let(:record_permission) { 'user.update' }
      end
    end

    describe 'updating name' do
      include_context 'when authenticated' do
        let(:user) do
          FactoryBot.create(:user, user_permission_list: [record_permission])
        end
      end

      let(:request) do
        put(record_url, data: {
              id: record.id,
              type: record_type(user),
              attributes: { first_name: 'my', last_name: 'name' }
            })
      end

      it do
        expect { request }.not_to(change { record.reload && record.username })
      end
    end

    describe 'updating password' do
      let(:old_password) { Faker::Internet.password(min_length: 12) }
      let(:new_password) { Faker::Internet.password(min_length: 12) }
      let(:record_url) { "/v1/users/#{user.id}" }

      include_context 'when authenticated' do
        let(:user) do
          FactoryBot.create(:user, user_permission_list: [record_permission],
                                   password: old_password)
        end
      end

      context 'with nil value' do
        let(:valid_attributes) { { password: nil } }
        let(:request) do
          put(record_url, data: {
                id: user.id,
                type: record_type(user),
                attributes: valid_attributes
              })
        end

        before do
          user.activated_at = Time.zone.now
          user.save
        end

        it_behaves_like '200 OK'
        it { expect { request }.not_to(change(record, :password_digest)) }
      end

      context 'with valid old password' do
        let(:valid_attributes) { { password: new_password, old_password: old_password } }
        let(:request) do
          put(record_url, data: {
                id: user.id,
                type: record_type(user),
                attributes: valid_attributes
              })
        end

        before { request && user.reload }

        it_behaves_like '200 OK'

        it { expect(user.authenticate(new_password)).to eq user }
      end

      context 'with invalid old password' do
        let(:valid_attributes) do
          { password: new_password, old_password:
          Faker::Internet.password(min_length: 12) }
        end
        let(:request) do
          put(record_url,
              data: {
                id: user.id,
                type: record_type(user),
                attributes: valid_attributes
              })
        end

        it_behaves_like '422 Unprocessable Entity'
      end

      context 'with another user' do
        let(:another_user) do
          FactoryBot.create(:user, password: old_password)
        end
        let(:valid_attributes) { { password: new_password, old_password: old_password } }
        let(:record_url) { "/v1/users/#{another_user.id}" }
        let(:request) do
          put(record_url, data: {
                id: another_user.id,
                type: record_type(another_user),
                attributes: valid_attributes
              })
        end

        before { request && another_user.reload }

        it_behaves_like '200 OK'

        it { expect(another_user.authenticate(new_password)).to eq false }
      end
    end

    describe 'when disabling user' do
      let(:request) do
        put(record_url, data: {
              id: record.id,
              type: record_type(record),
              attributes: valid_attributes
            })
      end

      context 'with another user' do
        include_context 'when authenticated' do
          let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
        end

        let(:valid_attributes) { { login_enabled: false } }

        before { request && record.reload }

        it { expect(record.login_enabled).to be false }
      end

      context 'when doing itself' do
        include_context 'when authenticated' do
          let(:user) { record }
        end
        let(:valid_attributes) { { login_enabled: false } }

        before { request && record.reload }

        it { expect(record.login_enabled).to be true }
      end
    end
  end
end
