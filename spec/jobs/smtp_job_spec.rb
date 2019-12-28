require 'rails_helper'

RSpec.describe SmtpJob, type: :job do
  describe '#perform' do
    let(:mail_alias) { FactoryBot.create(:mail_alias) }
    let(:mailgun_client) { Mailgun::Client.new }
    let(:mail) { ActionMailer::Base.deliveries.first }

    describe '#enable_smtp' do
      let(:job) { described_class.new(mail_alias, true) }

      before do
        ActionMailer::Base.deliveries = []
        allow(job).to receive(:mailgun_client) { mailgun_client }
        allow(mailgun_client).to receive(:post).and_return(true)

        perform_enqueued_jobs do
          VCR.use_cassette('mailgun_enable_smtp') { job.perform_now }
        end
      end

      it { expect(mailgun_client).to have_received(:post) }
      it { expect(mail.bcc).to eq mail_alias.mail_addresses }
      it { expect(mail.to).to eq ['mailbeheer@csvalpha.nl'] }
      it { expect(mail.subject).to eq "SMTP account voor #{mail_alias.email} aangemaakt" }
    end

    describe '#disable_smtp' do
      let(:job) { described_class.new(mail_alias, false) }

      before do
        ActionMailer::Base.deliveries = []
        allow(job).to receive(:mailgun_client) { mailgun_client }
        allow(mailgun_client).to receive(:delete).and_return(true)

        perform_enqueued_jobs do
          VCR.use_cassette('mailgun_disable_smtp') { job.perform_now }
        end
      end

      it { expect(mailgun_client).to have_received(:delete) }
      it { expect(mail.bcc).to eq mail_alias.mail_addresses }
      it { expect(mail.to).to eq ['mailbeheer@csvalpha.nl'] }
      it { expect(mail.subject).to eq "SMTP account voor #{mail_alias.email} opgeheven" }
    end
  end
end
