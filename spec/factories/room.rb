FactoryBot.define do
  factory :room do
    author do
      FactoryBot.create(:user)
    end

    house_name { Faker::Company.name }
    location { Faker::Address.street_name }
    contact { Faker::Internet.email }
    description { Faker::Hipster.paragraph }
    publicly_visible { false }

    trait(:public) { publicly_visible { true } }
  end
end
