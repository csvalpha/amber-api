require 'rails_helper'

RSpec.describe MailModerationReminderJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class }

    let(:mail_alias) { FactoryBot.create(:mail_alias, :with_moderator) }

    before do
      ActionMailer::Base.deliveries = []

      perform_enqueued_jobs(except: job) do
        job.perform_now(stored_mail.id)
      end
    end

    context 'when expiring within 48 hours' do
      let(:stored_mail) do
        FactoryBot.create(:stored_mail, mail_alias: mail_alias, received_at: 1.day.ago)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
      it { expect { job.perform_now(stored_mail.id) }.to have_enqueued_job(job) }
    end

    context 'when expiring within 24 hours' do
      let(:stored_mail) do
        FactoryBot.create(:stored_mail, mail_alias: mail_alias, received_at: 2.days.ago)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
      it { expect { job.perform_now(stored_mail.id) }.not_to have_enqueued_job(job) }
    end

    context 'when accepted or rejected' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, :deleted) }

      it { expect(ActionMailer::Base.deliveries.count).to eq 0 }
      it { expect { job.perform_now(stored_mail.id) }.not_to have_enqueued_job(job) }
    end
  end
end
