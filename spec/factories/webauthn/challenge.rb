FactoryBot.define do
  factory :challenge, class: 'Webauthn::Challenge' do
    association :user
    challenge { Faker::Book.title }
  end
end
