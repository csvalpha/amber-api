FactoryBot.define do
  factory :room_advert do
    author do
      FactoryBot.create(:user)
    end

    house_name { Faker::Company.name }
    contact { Faker::Internet.email }
    location { Faker::Address.street_name }
    location { Faker::Date.forward(days: 31) }
    description { Faker::Hipster.paragraph }
    publicly_visible { false }

    trait(:public) { publicly_visible { true } }
  end
end
