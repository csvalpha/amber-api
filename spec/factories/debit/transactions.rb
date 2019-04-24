FactoryBot.define do
  factory :transaction, class: Debit::Transaction do
    description { Faker::Book.title }
    amount { rand(0..250.0) }

    collection
    user
  end
end
