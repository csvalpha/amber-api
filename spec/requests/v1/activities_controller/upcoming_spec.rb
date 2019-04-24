require 'rails_helper'

describe V1::ActivitiesController do
  describe 'GET /activities/upcoming', version: 1 do
    let(:record_url) { '/v1/activities?filter[upcoming]' }
    let(:record_permission) { 'activity.read' }
    let(:request) { get(record_url) }
    let(:current_activities) do
      Array.new(2) do
        FactoryBot.create(:activity, start_time: Faker::Time.between(3.days.ago, 2.days.ago),
                                     end_time: Faker::Time.between(1.day.from_now,
                                                                   2.days.from_now))
      end
    end
    let(:future_activities) do
      Array.new(3) do
        FactoryBot.create(:activity,
                          start_time: Faker::Time.between(1.day.from_now, 2.days.from_now),
                          end_time: Faker::Time.between(3.days.from_now, 4.days.from_now))
      end
    end
    let(:far_future_activities) do
      Array.new(2) do
        FactoryBot.create(:activity,
                          start_time: Faker::Time.between(5.days.from_now, 6.days.from_now),
                          end_time: Faker::Time.between(7.days.from_now, 8.days.from_now))
      end
    end
    let(:passed_activity) do
      FactoryBot.create(:activity, start_time: Faker::Time.between(5.days.ago, 4.days.ago),
                                   end_time: Faker::Time.between(2.days.ago, 1.day.ago))
    end
    let(:records) do
      current_activities + future_activities + far_future_activities + [passed_activity]
    end

    before do
      current_activities
      future_activities
      far_future_activities
      passed_activity
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '200 OK'
      it { expect(json_object_ids.count).to equal(7) }
      it { expect(json_object_ids).to include(far_future_activities[0].id) }
      it { expect(json_object_ids).to include(far_future_activities[1].id) }
      it { expect(json_object_ids).not_to include(passed_activity.id) }

      context 'when paginated' do
        let(:record_url) { '/v1/activities/?filter[upcoming]&page[size]=5' }
        let(:expected_ids) { (future_activities + current_activities).pluck(:id) }

        it_behaves_like '200 OK'

        it { expect(json_object_ids).to match_array(expected_ids) }
        it { expect(json_object_ids.count).to equal(5) }
        it { expect(json_object_ids).not_to include(far_future_activities[0].id) }
        it { expect(json_object_ids).not_to include(far_future_activities[1].id) }
        it { expect(json_object_ids).not_to include(passed_activity.id) }
      end
    end
  end
end
