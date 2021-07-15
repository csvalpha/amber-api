FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    publicly_visible { false }
    association :author, factory: :user
    group

    trait(:public) { publicly_visible { true } }
  end
end
