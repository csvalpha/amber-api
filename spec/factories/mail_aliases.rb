FactoryBot.define do
  factory :mail_alias do
    email { "#{Faker::Internet.user_name}@test.csvalpha.nl" }
    moderation_type { :open }
    user

    trait :with_group do
      group
      user { nil }
    end

    trait :with_user do
      user
      group { nil }
    end

    trait :with_moderator do
      moderation_type { :moderated }
      moderator_group factory: %i[group with_user]
    end
  end
end
