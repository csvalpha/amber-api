require 'rails_helper'

RSpec.describe MailgunFetcher::Mail do
  let(:message_url) do
    'https://se.api.mailgun.net/v3/domains/csvalpha.nl/messages/eyJwIjpmYWxzZSwiayI6IjZjZmYzYzM1LTdkMDctNGYyMC1iYzczLTI2NjU5MGE1OGZiYiIsInMiOiI5N2MxYmJjMjU5IiwiYyI6InRhbmtiIn0='
  end
  let(:mail) { described_class.new(message_url) }

  describe '#subject' do
    before { VCR.use_cassette('mailgun_fetcher_mail') { mail.__send__(:json_response) } }

    it { expect(mail.sender).to eq 'from@csvalpha.nl' }
    it { expect(mail.from).to eq '"Sender" <from@csvalpha.nl>' }
    it { expect(mail.subject).to eq 'This is the subject' }
    it { expect(mail.plain_body).to eq 'This is the body' }
    it { expect(mail.received_at).to eq Time.new(2018, 3, 10, 11, 25, 19, '+01:00') }
    it { expect(mail.attachments.first[:name]).to eq 'ruby.png' }
  end
end
