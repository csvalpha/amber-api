require 'rails_helper'

RSpec.describe SmtpJob do
  describe '#perform' do
    let(:mail_alias) { create(:mail_alias) }
    let(:client) { Improvmx::Client.new }
    let(:mail) { ActionMailer::Base.deliveries.first }

    describe '#enable_smtp' do
      let(:job) { described_class.new(mail_alias.id, true) }
      let(:management_mail) { ActionMailer::Base.deliveries.second }

      before do
        ActionMailer::Base.deliveries = []
        allow(job).to receive(:client) { client }
        allow(client).to receive(:create_smtp).and_return(true)

        perform_enqueued_jobs do
          job.perform_now
        end
      end

      it { expect(client).to have_received(:create_smtp) }
      it { expect(ActionMailer::Base.deliveries.size).to eq 2 }
      it { expect(mail.bcc).to eq mail_alias.mail_addresses }
      it { expect(mail.subject).to eq "Je kunt nu mail versturen vanaf #{mail_alias.email}!" }

      it { expect(management_mail.to).to eq [Rails.application.config.x.mailbeheer_email] }

      it {
        expect(management_mail.subject).to eq "SMTP account voor #{mail_alias.email} aangemaakt"
      }
    end

    describe '#disable_smtp' do
      let(:job) { described_class.new(mail_alias.id, false) }

      before do
        ActionMailer::Base.deliveries = []
        allow(job).to receive(:client) { client }
        allow(client).to receive(:delete_smtp).and_return(true)

        perform_enqueued_jobs do
          job.perform_now
        end
      end

      it { expect(client).to have_received(:delete_smtp) }
      it { expect(mail.bcc).to eq mail_alias.mail_addresses }
      it { expect(mail.to).to eq [Rails.application.config.x.mailbeheer_email] }
      it { expect(mail.subject).to eq "SMTP account voor #{mail_alias.email} opgeheven" }
    end
  end
end
