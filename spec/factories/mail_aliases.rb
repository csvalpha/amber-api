FactoryBot.define do
  factory :mail_alias do
    email { "#{Faker::Internet.user_name}@#{Rails.application.config.x.mail_domains.sample}" }
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
      association :moderator_group, factory: :group
    end
  end
end
