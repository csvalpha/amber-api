FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name_prefix { [nil, 'van', 'de', 'van de'].sample }
    last_name { Faker::Name.last_name }
    nickname { Faker::Name.first_name }
    birthday { Faker::Date.between(from: 27.years.ago, to: 17.years.ago) }
    address { Faker::Address.street_address }
    postcode { Faker::Address.postcode }
    city { Faker::Address.city }
    vegetarian { Faker::Boolean }
    food_preferences { [nil, 'Noten', 'Pinda'].sample }
    study { Faker::Company.profession }
    start_study { Faker::Date.between(from: 10.years.ago, to: 1.year.ago) }
    phone_number { Faker::PhoneNumber.phone_number }
    emergency_contact { Faker::Name.name }
    emergency_number { Faker::PhoneNumber.phone_number }
    ifes_data_sharing_preference { Faker::Boolean }
    info_in_almanak { Faker::Boolean }
    picture_publication_preference { %w[always_publish always_ask never_publish].sample }
    almanak_subscription_preference { %w[physical digital no_subscription].sample }
    digtus_subscription_preference { %w[physical digital no_subscription].sample }
    user_details_sharing_preference { %w[all_users members_only hidden].sample }
    username { nil }

    sequence(:email) { |n| Faker::Internet.safe_email(name: "#{Faker::Internet.user_name}#{n}") }

    password = Faker::Internet.password(min_length: 12)
    password { password }
    password_confirmation { password }

    otp_required { false }
    login_enabled { true }

    trait(:webdav_enabled) { webdav_secret_key { SecureRandom.hex(32) } }

    transient do
      user_permission_list { [] }
      groups { [] }
    end

    after :create do |user, evaluator|
      user.user_permissions << evaluator.user_permission_list.compact.map do |name|
        FactoryBot.create(:permission, name: name)
      end

      evaluator.groups.each do |group|
        FactoryBot.create(:membership, group: group, user: user)
      end
    end
  end
end
