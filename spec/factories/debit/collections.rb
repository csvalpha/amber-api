FactoryBot.define do
  factory :collection, class: 'Debit::Collection' do
    name { Faker::Book.title }
    date { Faker::Time.between(1.month.from_now, 2.months.from_now, :day) }
    association :author, factory: :user
  end
end
