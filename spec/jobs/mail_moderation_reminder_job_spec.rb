require 'rails_helper'

RSpec.describe MailModerationReminderJob, type: :job do
  describe '#perform' do
    let(:mail_alias) { FactoryBot.create(:mail_alias, :with_moderator) }

    before do
      ActionMailer::Base.deliveries = []

      perform_enqueued_jobs(except: described_class) do
        described_class.perform_now(stored_mail)
      end
    end

    context 'when sent one day ago' do
      let(:stored_mail) do
        FactoryBot.create(:stored_mail, mail_alias: mail_alias, received_at: 1.day.ago)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
      it { expect{ described_class.perform_now(stored_mail) }.to have_enqueued_job(described_class) }
    end

    context 'when sent two days ago' do
      let(:stored_mail) do
        FactoryBot.create(:stored_mail, mail_alias: mail_alias, received_at: 2.days.ago)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }

      it do
        expect{ described_class.perform_now(stored_mail) }.not_to have_enqueued_job(described_class)
      end
    end
  end
end
