FactoryBot.define do
  factory :collection, class: 'Debit::Collection' do
    name { Faker::Book.title }
    date { Faker::Time.between(from: 1.month.from_now, to: 2.months.from_now) }
    association :author, factory: :user
  end
end
