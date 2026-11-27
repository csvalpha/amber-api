FactoryBot.define do
  factory :photo_album do
    title { Faker::Book.title }
    visibility { 'members' }
    author factory: %i[user]
    group

    trait(:public) { visibility { 'public' } }
    trait(:alumni) { visibility { 'alumni' } }
  end
end
