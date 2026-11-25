FactoryBot.define do
  factory :alumni_contribution do
    user
    sponsoring_amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    help_digtus { [true, false].sample }
    help_kring { [true, false].sample }
    help_vereniging { [true, false].sample }
    help_anders { [nil, Faker::Lorem.sentence].sample }
  end
end
