FactoryBot.define do
  factory :photo_tag do
    x { rand(0.0..100.0) }
    y { rand(0.0..100.0) }
    author factory: %i[user]
    tagged_user factory: %i[user]

    photo
  end
end
