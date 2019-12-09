FactoryBot.define do
  factory :stored_mail do
    message_url { Faker::Internet.url }
    received_at { Faker::Time.between(from: 3.days.ago, to: Date.yesterday) }
    sender { "#{Faker::Name.first_name} <#{Faker::Internet.safe_email}>" }
    mail_alias { FactoryBot.create(:mail_alias, :with_group) }
    subject { Faker::Book.title }

    trait :expired do
      created_at { Faker::Time.between(from: 5.days.ago, to: 7.days.ago) }
    end

    trait :deleted do
      created_at { Faker::Time.between(from: 5.weeks.ago, to: 6.weeks.ago) }
      deleted_at { 1.day.ago }
    end
  end
end
