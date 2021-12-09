FactoryBot.define do
  factory :credential, class: 'Webauthn::Credential' do
    association :user
    nickname { Faker::Book.title }
    external_id { Faker::Lorem.characters(number: 150) }
    public_key { Faker::Lorem.characters(number: 100) }
    sign_count { 0 }
  end
end
