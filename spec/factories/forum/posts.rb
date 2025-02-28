FactoryBot.define do
  factory :post, class: 'Forum::Post' do
    message { Faker::Hipster.paragraph }
    author factory: %i[user]
    thread
  end
end
