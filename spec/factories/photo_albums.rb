FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    publicly_visible { false }
    author factory: %i[user]
    group

    trait(:public) { publicly_visible { true } }
  end
end
