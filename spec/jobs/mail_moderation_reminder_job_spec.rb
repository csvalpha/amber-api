require 'rails_helper'

RSpec.describe MailModerationReminderJob, type: :job do
  describe '#perform' do
    before do
      ActionMailer::Base.deliveries = []

      perform_enqueued_jobs do
        described_class.perform_now(stored_mail)
      end
    end

    context 'when sent one day ago' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, received_at: 1.day.ago) }

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    end

    context 'when sent two days ago' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, received_at: 2.days.ago) }

      it { expect(ActionMailer::Base.deliveries.count).to eq 2 }
    end
  end
end
