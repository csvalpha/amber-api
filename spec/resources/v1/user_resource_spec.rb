require 'rails_helper'

RSpec.describe V1::UserResource, type: :resource do
  let(:user) { create(:user, user_details_sharing_preference: 'hidden') }
  let(:context) { { user: } }
  let(:options) { { context: } }

  describe '#fetchable_fields' do
    let(:basic_fields) do
      %i[id created_at updated_at username first_name last_name_prefix last_name full_name nickname
         avatar_url avatar_thumb_url groups active_groups memberships mail_aliases
         group_mail_aliases photos permissions user_permissions mandates]
    end
    let(:update_fields) do
      %i[login_enabled otp_required activated_at emergency_contact
         emergency_number ifes_data_sharing_preference info_in_almanak
         almanak_subscription_preference digtus_subscription_preference
         user_details_sharing_preference allow_sofia_sharing
         sidekiq_access setup_complete]
    end
    let(:read_fields) do
      %i[picture_publication_preference]
    end
    let(:user_details_fields) do
      %i[email birthday address postcode city phone_number food_preferences vegetarian
         study start_study trailer_drivers_license]
    end
    let(:sofia_fields) do
      %i[email birthday]
    end
    let(:another_user) { create(:user, user_details_sharing_preference: 'hidden') }
    let(:resource) { described_class.new(another_user, context) }

    context 'when without permission' do
      it { expect(resource.fetchable_fields).to match_array(basic_fields) }
    end

    context 'when with update permission' do
      let(:user) { create(:user, user_permission_list: ['user.update']) }
      let(:fields) { basic_fields + update_fields }

      it { expect(resource.fetchable_fields).to match_array(fields + user_details_fields) }
    end

    context 'when with read permission' do
      let(:user) { create(:user, user_permission_list: ['user.read']) }
      let(:fields) { basic_fields + read_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when with user_details_sharing_preference set to hidden' do
      let(:another_user) do
        create(:user, user_details_sharing_preference: 'hidden')
      end
      let(:fields) { basic_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when with read permission and user_details_sharing_preference set to members_only' do
      let(:user) { create(:user, user_permission_list: ['user.read']) }
      let(:another_user) do
        create(:user, user_details_sharing_preference: 'members_only')
      end
      let(:fields) { basic_fields + read_fields + user_details_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when with read permission and user_details_sharing_preference set to all_users' do
      let(:user) { create(:user, user_permission_list: ['user.read']) }
      let(:another_user) do
        create(:user, user_details_sharing_preference: 'all_users')
      end
      let(:fields) { basic_fields + read_fields + user_details_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when without read permission and user_details_sharing_preference set to all_users' do
      let(:another_user) { create(:user, user_details_sharing_preference: 'all_users') }
      let(:fields) { basic_fields + user_details_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when without read permission and
 user_details_sharing_preference set to members_only' do
      let(:another_user) do
        create(:user, user_details_sharing_preference: 'members_only')
      end
      let(:fields) { basic_fields }

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when record is current_user' do
      let(:another_user) { user }
      let(:fields) do
        basic_fields + update_fields +
          read_fields + user_details_fields + %i[ical_secret_key]
      end

      it { expect(resource.fetchable_fields).to match_array(fields) }
    end

    context 'when with application' do
      let(:application) { create(:application) }
      let(:context) { { user:, application: } }

      it { expect(resource.fetchable_fields).to match_array(basic_fields) }

      context 'when with sofia scope' do
        let(:application) { create(:application, scopes: 'public sofia') }

        context 'when without allowance' do
          it { expect(resource.fetchable_fields).to match_array(basic_fields) }
        end

        context 'when with allowance' do
          let(:another_user) { create(:user, allow_sofia_sharing: true) }

          it { expect(resource.fetchable_fields).to match_array(basic_fields + sofia_fields) }
        end
      end
    end
  end

  describe '#createable_fields' do
    let(:another_user) { create(:user) }
    let(:context) { { user:, model: another_user } }
    let(:creatable_fields) { described_class.creatable_fields(context) }
    let(:basic_fields) do
      %i[avatar nickname email address postcode city phone_number
         food_preferences vegetarian study start_study
         almanak_subscription_preference
         digtus_subscription_preference emergency_contact emergency_number]
    end
    let(:permissible_fields) do
      %i[first_name last_name_prefix last_name birthday
         user_permissions login_enabled]
    end
    let(:current_user_fields) do
      %i[otp_required password user_details_sharing_preference allow_sofia_sharing
         info_in_almanak ifes_data_sharing_preference picture_publication_preference
         trailer_drivers_license sidekiq_access setup_complete]
    end

    context 'when without permission' do
      it { expect(creatable_fields).to match_array(basic_fields) }
    end

    context 'when record is current user' do
      let(:another_user) { user }

      it { expect(creatable_fields).to match_array(basic_fields + current_user_fields) }
    end

    context 'when with create permisison' do
      let(:user) { create(:user, user_permission_list: ['user.create']) }

      it {
        expect(creatable_fields).to match_array(basic_fields + permissible_fields)
      }

      context 'when record is current user' do
        let(:another_user) { user }

        it {
          expect(creatable_fields).to match_array(basic_fields + permissible_fields +
                                                    current_user_fields - [:login_enabled])
        }
      end
    end
  end

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(User, filter, options) }

    describe 'upcoming_birthdays' do
      let(:filter) { { upcoming_birthdays: true } }

      before do
        create(:user, user_details_sharing_preference: 'all_users',
                      birthday: Faker::Date.between(from: 1.day.from_now,
                                                    to: 2.days.from_now))
        create(:user, user_details_sharing_preference: 'hidden',
                      birthday: Faker::Date.between(from: 1.day.from_now,
                                                    to: 2.days.from_now))
      end

      context 'when with update permission' do
        let(:user) do
          create(:user, user_details_sharing_preference: 'members_only',
                        user_permission_list: ['user.update'],
                        birthday: Faker::Date.between(from: 1.day.from_now,
                                                      to: 2.days.from_now))
        end

        it { expect(filtered.size).to eq 3 }
      end

      context 'when without permission' do
        let(:user) do
          create(:user, user_details_sharing_preference: 'members_only',
                        birthday: Faker::Date.between(from: 1.day.from_now,
                                                      to: 2.days.from_now))
        end

        it { expect(filtered.size).to eq 2 }
      end

      context 'when with own user details sharing set to hidden' do
        let(:user) do
          create(:user, user_details_sharing_preference: 'hidden',
                        birthday: Faker::Date.between(from: 1.day.from_now,
                                                      to: 2.days.from_now))
        end

        it { expect(filtered.size).to eq 2 }
      end
    end

    describe 'me' do
      let(:filter) { { me: true } }

      it { expect(filtered.size).to eq 1 }
      it { expect(filtered.first).to eq user }
    end

    describe 'group' do
      let(:member) { create(:user) }
      let(:group) { create(:group, users: [member]) }
      let(:filter) { { group: group.name } }

      it { expect(filtered.size).to eq 1 }
      it { expect(filtered.first).to eq member }
    end
  end
end
