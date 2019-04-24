FactoryBot.define do
  factory :membership do
    start_date { Faker::Date.between(12.months.ago, 1.month.ago) }
    function { Faker::Job.title }
    group
    user
  end
end
