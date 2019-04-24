FactoryBot.define do
  factory :post, class: Forum::Post do
    message { Faker::Hipster.paragraph }
    association :author, factory: :user
    thread
  end
end
