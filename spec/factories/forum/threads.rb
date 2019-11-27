FactoryBot.define do
  factory :thread, class: 'Forum::Thread' do
    title { Faker::Hipster.sentence(4, true, 2) }
    association :author, factory: :user
    category

    trait(:closed) do
      closed_at { Time.zone.now }
    end
  end
end
