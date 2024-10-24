FactoryBot.define do
  factory :vacancy do
    author do
      FactoryBot.create(:user)
    end

    group do
      FactoryBot.create(:group,
                        users: [author])
    end

    title { Faker::Book.title }
    description { Faker::Hipster.paragraph }
    workload { Faker::Hipster.paragraph }
    workload_peak { Faker::Hipster.paragraph }
    contact { Faker::PhoneNumber.phone_number }
    deadline { Faker::Date.between(from: 1.day.from_now, to: 10.days.from_now) }
  end
end
