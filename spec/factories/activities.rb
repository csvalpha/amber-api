FactoryBot.define do
  factory :activity do
    association :author, factory: :user
    group

    title { Faker::Book.title }
    description { Faker::Hipster.paragraph }
    price { rand(0..1000.0) }
    location { Faker::Games::Pokemon.location }
    start_time { Faker::Time.between(from: 1.day.ago, to: Time.zone.today) }
    end_time { Faker::Time.between(from: 1.day.from_now, to: 2.days.from_now) }
    category do
      %w[algemeen societeit vorming kring 
         choose ifes ozon disputen kiemgroepen huizen extern eerstejaars curiositates].sample
    end
    publicly_visible { false }

    trait(:public) { publicly_visible { true } }

    trait :with_form do
      form
    end

    trait :full_day do
      start_time { Faker::Date.between(from: 1.day.ago, to: Time.zone.today) }
      end_time { Faker::Date.between(from: 1.day.from_now, to: 2.days.from_now) }
    end
  end
end
