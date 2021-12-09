FactoryBot.define do
  factory :credential, class: 'Webauthn::Credential' do
    association :user
    nickname { Faker::Book.title }
    external_id { Faker::String.random(length: 150) }
    public_key { Faker::String.random(length: 100) }
    sign_count { 0 }
  end
end
