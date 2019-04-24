FactoryBot.define do
  factory :stored_mail do
    message_url { Faker::Internet.url }
    received_at { Faker::Time.between(3.days.ago, Date.yesterday) }
    sender { "#{Faker::Name.first_name} <#{Faker::Internet.safe_email}>" }
    mail_alias { FactoryBot.create(:mail_alias, :with_group) }
    subject { Faker::Book.title }
  end
end
