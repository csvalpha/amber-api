FactoryBot.define do
  factory :poll do
    author factory: %i[user]
    form
  end
end
