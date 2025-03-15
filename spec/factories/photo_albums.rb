FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    visibility do
      %w[public alumni members].sample
    end
    author factory: %i[user]
    group

    trait(:public) { visibility { 'public' } }
    trait(:alumni) { visibility { %w[alumni public].sample } }
  end
end
