FactoryBot.define do
  factory :inbound_email, class: 'ActionMailbox::InboundEmail' do
    from { "#{Faker::Name.first_name} <#{Faker::Internet.email}>" }
    to { "#{Faker::Internet.user_name}@test.csvalpha.nl" }
    subject { Faker::Book.title }

    initialize_with do
      create_inbound_email_from_mail(**attributes) do |mail|
        mail.text_part do |part|
          part.body Faker::Hipster.paragraph(sentence_count: 3)
        end
      end
    end
  end
end

def create_inbound_email_from_mail(**mail_options, &)
  mail = Mail.new(mail_options, &)

  ActionMailbox::InboundEmail.create_and_extract_message_id! mail.to_s, status: :processing
end
