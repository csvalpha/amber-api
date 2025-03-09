FactoryBot.define do
  factory :collection, class: 'Debit::Collection' do
    name { Faker::Book.title }
    date { Faker::Time.between(from: 1.month.from_now, to: 2.months.from_now) }
    author factory: %i[user]
  end
end
