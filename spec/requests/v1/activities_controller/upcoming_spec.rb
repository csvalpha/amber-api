require 'rails_helper'

describe V1::ActivitiesController do
  describe 'GET /activities/upcoming', version: 1 do
    let(:record_url) { '/v1/activities?filter[upcoming]' }
    let(:record_permission) { 'activity.read' }
    let(:request) { get(record_url) }
    let(:current_activities) do
      Array.new(2) do
        create(:activity, start_time: Faker::Time.between(from: 3.days.ago,
                                                          to: 2.days.ago),
                          end_time: Faker::Time.between(from: 1.day.from_now,
                                                        to: 2.days.from_now))
      end
    end
    let(:future_activities) do
      Array.new(3) do
        create(:activity,
               start_time: Faker::Time.between(from: 1.day.from_now,
                                               to: 2.days.from_now),
               end_time: Faker::Time.between(from: 3.days.from_now,
                                             to: 4.days.from_now))
      end
    end
    let(:far_future_activities) do
      Array.new(2) do
        create(:activity,
               start_time: Faker::Time.between(from: 5.days.from_now,
                                               to: 6.days.from_now),
               end_time: Faker::Time.between(from: 7.days.from_now,
                                             to: 8.days.from_now))
      end
    end
    let(:passed_activity) do
      create(:activity, start_time: Faker::Time.between(from: 5.days.ago,
                                                        to: 4.days.ago),
                        end_time: Faker::Time.between(from: 2.days.ago,
                                                      to: 1.day.ago))
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
        let(:user) { create(:user, user_permission_list: [record_permission]) }
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
