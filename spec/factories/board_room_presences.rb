FactoryBot.define do
  factory :board_room_presence do
    start_time { Faker::Time.between(3.days.ago, 5.days.ago) }
    end_time { Faker::Time.between(10.days.from_now, 5.days.from_now) }
    status { %w[present busy absent].sample }
    user

    trait(:future) { start_time { Faker::Time.between(1.day.from_now, 4.days.from_now) } }
    trait(:history) { end_time { Faker::Time.between(2.days.ago, 1.day.ago) } }
  end
end
