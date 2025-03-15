FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    visibility { %w[public alumni members].sample }
    association :author, factory: :user
    association :group

    trait :public do
      visibility { 'public' }
    end

    trait :alumni do
      visibility { 'alumni' }
    end
  end
end
