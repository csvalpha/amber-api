FactoryBot.define do
  factory :photo_tag do
    x { rand(0.0..100.0) }
    y { rand(0.0..100.0) }
    association :author, factory: :user
    association :tagged_user, factory: :user

    photo
  end
end
