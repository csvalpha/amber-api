FactoryBot.define do
  factory :poll do
    association :author, factory: :user
    form
  end
end
