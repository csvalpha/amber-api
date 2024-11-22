FactoryBot.define do
  factory :study_room_presence do
    start_time { Faker::Time.between(from: 3.days.ago, to: 5.days.ago) }
    end_time { Faker::Time.between(from: 10.days.from_now, to: 5.days.from_now) }
    status { %w[chilling studying banaan].sample }
    user

    trait(:future) { start_time { Faker::Time.between(from: 1.day.from_now, to: 4.days.from_now) } }
    trait(:history) { end_time { Faker::Time.between(from: 2.days.ago, to: 1.day.ago) } }
  end
end
