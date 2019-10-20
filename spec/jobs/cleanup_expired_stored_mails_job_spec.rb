require 'rails_helper'

RSpec.describe CleanupExpiredStoredMailsJob, type: :job do
  describe '#perform' do
    let(:recent_email) { FactoryBot.create(:stored_mail) }
    let(:slack_message_job_class) { class_double(SlackMessageJob).as_stubbed_const }

    subject(:job) { described_class.new }

    before do
      recent_email

      allow(slack_message_job_class).to receive(:perform_later)
    end

    context 'when with no old emails' do
      before { job.perform }

      it do
        expect(slack_message_job_class).to have_received(:perform_later)
          .with('No email cleanup needed', channel: '#monitoring')
      end
    end

    context 'when with some deleted emails and expired emails' do
      let(:expired_email) { FactoryBot.create(:stored_mail, :expired) }
      let(:deleted_email) { FactoryBot.create(:stored_mail, :deleted) }
      let(:another_deleted_email) { FactoryBot.create(:stored_mail, :deleted) }

      before do
        expired_email
        deleted_email
        another_deleted_email

        job.perform
      end

      it do
        expect(slack_message_job_class).to have_received(:perform_later).with(
          'Email cleanup finished. 2 expired emails really destroyed; '\
          '1 ignored (not-moderated) emails soft-deleted',
          channel: '#monitoring'
        )
      end
    end
  end
end
