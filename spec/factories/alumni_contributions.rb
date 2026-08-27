FactoryBot.define do
  factory :alumni_contribution do
    user
    sponsoring_amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    help_digtus { Faker::Boolean.boolean }
    help_kring { Faker::Boolean.boolean }
    help_vereniging { Faker::Boolean.boolean }
    help_anders { [nil, Faker::Lorem.sentence].sample }
  end
end
