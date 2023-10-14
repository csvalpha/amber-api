require 'rails_helper'

describe V1::ActivitiesController, type: :controller do
  describe 'GET /ical/activities' do
    let(:activity) { create(:activity) }
    let(:permissions) { ['activity.read', 'user.read'] }
    let(:user) do
      create(:user, activated_at: Time.zone.now,
                    user_permission_list: permissions)
    end
    let(:birthday_users) do
      User.active_users_for_group(Group.find_by(name: 'Leden'))
          .where.not(birthday: nil)
    end

    before { activity }

    subject(:request) { get('ical') }

    it_behaves_like '401 Unauthorized'

    context 'when authenticated' do
      describe 'with disabled but correct ical secret key key' do
        let(:user) do
          create(:user,
                 login_enabled: false,
                 user_permission_list: permissions)
        end

        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        it_behaves_like '401 Unauthorized'
      end

      describe 'with incorrect ical secret key' do
        subject(:request) { get('ical', params: { user_id: user.id, key: 'deadbeef' }) }

        it_behaves_like '401 Unauthorized'
      end

      describe 'with unactivated account' do
        let(:user) { create(:user, user_permission_list: permissions) }

        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        it_behaves_like '401 Unauthorized'
      end

      describe 'without activity permission' do
        let(:user) { create(:user, activated_at: Time.zone.now) }

        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        it_behaves_like '401 Unauthorized'
      end

      describe 'without user permission' do
        let(:user) do
          create(:user, activated_at: Time.zone.now, user_permission_list: ['activity.read'])
        end
        let(:ical_events) { Icalendar::Calendar.parse(request.body).first.events }

        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        it { expect(ical_events.count).to eq Activity.count }
      end

      describe 'with activated, login_enabled account with permission and correct ical secret' do
        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        let(:ical_event) { Icalendar::Calendar.parse(request.body).first.events.first }

        it_behaves_like '200 OK'
        it { expect(ical_event.summary).to include(activity.title) }
        it { expect(ical_event.description).to include("/activities/#{activity.id}") }
      end

      describe 'without any categories' do
        subject(:request) { get('ical', params: { user_id: user.id, key: user.ical_secret_key }) }

        let(:ical_events) { Icalendar::Calendar.parse(request.body).first.events }

        it { expect(ical_events.count).to eq Activity.count + birthday_users.count }
      end

      describe 'with a subset of all categories' do
        subject(:request) do
          get('ical', params: { user_id: user.id, key: user.ical_secret_key,
                                categories: 'algemeen,sociëteit,vorming,invalid_cat,birthdays' })
        end

        let(:group) { create(:group, name: 'Leden') }
        let(:membership) { create(:membership, user: user, group: group, start_date: 1.month.ago) }

        let(:activity) { create(:activity, category: 'algemeen') }
        let(:second_activity) { create(:activity, category: 'vorming') }

        let(:filtered_activity) do
          create(:activity, title: 'thisshouldbefiltered218', category: 'choose')
        end

        let(:ical_events) do
          Icalendar::Calendar.parse(request.body).first.events.sort_by do |event|
            [event.dtstart, event.dtend]
          end
        end

        before do
          group
          membership
          activity
          second_activity
          filtered_activity
        end

        it { expect(ical_events.map(&:summary).to_s).to include("Verjaardag #{user.full_name}") }
        it { expect(ical_events.map(&:summary).to_s).to include(activity.title) }
        it { expect(request.body).not_to include(filtered_activity.title) }
        it { expect(ical_events.count).to eq 2 + birthday_users.count }
      end
    end
  end
end
