FactoryBot.define do
  factory :stored_mail do
    inbound_email

    received_at { Faker::Time.between(from: 3.days.ago, to: Date.yesterday) }
    mail_alias { FactoryBot.create(:mail_alias, :with_group) }

    trait :deleted do
      created_at { Faker::Time.between(from: 5.weeks.ago, to: 6.weeks.ago) }
      deleted_at { 1.day.ago }
    end
  end
end
