FactoryBot.define do
  factory :quickpost_message do
    message { Faker::Lorem.sentence }
    association :author, factory: :user
  end
end
