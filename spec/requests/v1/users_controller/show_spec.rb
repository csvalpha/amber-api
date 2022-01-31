require 'rails_helper'

describe V1::UsersController do
  describe 'GET /users/:id', version: 1 do
    let(:record) { create(:user, user_details_sharing_preference: 'hidden') }
    let(:record_url) { "/v1/users/#{record.id}" }
    let(:record_permission) { 'user.read' }

    subject(:request) { get(record_url) }

    context 'when user_details_sharing_preference is set to hidden' do
      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.update' }
        let(:conditional_attributes) do
          %w[login_enabled activated_at]
        end
      end

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.read' }
        let(:record_permission) { nil }
        let(:conditional_attributes) do
          %w[picture_publication_preference]
        end
      end

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.update' }
        let(:record_permission) { 'user.read' }
        let(:conditional_attributes) do
          %w[login_enabled otp_required
             activated_at emergency_contact emergency_number info_in_almanak
             almanak_subscription_preference digtus_subscription_preference
             ifes_data_sharing_preference user_details_sharing_preference]
        end
      end
    end

    context 'when user_details_sharing_preference is set to nil' do
      let(:record) { create(:user, user_details_sharing_preference: nil) }

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.update' }
        let(:conditional_attributes) do
          %w[login_enabled activated_at]
        end
      end

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.read' }
        let(:record_permission) { nil }
        let(:conditional_attributes) do
          %w[picture_publication_preference]
        end
      end

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.update' }
        let(:record_permission) { 'user.read' }
        let(:conditional_attributes) do
          %w[login_enabled otp_required
             activated_at emergency_contact emergency_number info_in_almanak
             almanak_subscription_preference digtus_subscription_preference
             ifes_data_sharing_preference user_details_sharing_preference]
        end
      end
    end

    context 'when user_details_sharing_preference is set to all_users' do
      let(:record) { create(:user, user_details_sharing_preference: 'all_users') }

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.read' }
        let(:record_permission) { nil }
        let(:conditional_attributes) do
          %w[picture_publication_preference]
        end
      end
    end

    context 'when user_details_sharing_preference is set to members_only' do
      let(:record) { create(:user, user_details_sharing_preference: 'members_only') }

      it_behaves_like 'a model with conditionally serializable attributes' do
        let(:conditional_permission) { 'user.read' }
        let(:record_permission) { nil }
        let(:conditional_attributes) do
          %w[picture_publication_preference email birthday address
             postcode city phone_number food_preferences vegetarian study start_study]
        end
      end
    end

    context 'when current user' do
      include_context 'when authenticated' do
        let(:user) { record }
      end

      authenticated_attributes = %w[
        email birthday address postcode phone_number study
        food_preferences vegetarian start_study ical_secret_key webdav_secret_key
        city picture_publication_preference info_in_almanak
        almanak_subscription_preference digtus_subscription_preference
        emergency_contact emergency_number ifes_data_sharing_preference
        user_details_sharing_preference
      ]
      it_behaves_like '200 OK'
      it {
        expect(json['data']['attributes'].keys).to include(*authenticated_attributes)
      }
    end
  end
end
