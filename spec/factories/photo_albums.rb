FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    publicly_visible { false }

    trait(:public) { publicly_visible { true } }
  end
end
