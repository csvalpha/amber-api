FactoryBot.define do
  factory :category, class: Forum::Category do
    name { Faker::Book.title }
  end
end
