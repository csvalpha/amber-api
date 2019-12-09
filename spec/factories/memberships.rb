FactoryBot.define do
  factory :membership do
    start_date { Faker::Date.between(from: 12.months.ago, to: 1.month.ago) }
    function { Faker::Job.title }
    group
    user
  end
end
