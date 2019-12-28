require 'rails_helper'

RSpec.describe MailModerationReminderJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class.new }

    before do
      ActionMailer::Base.deliveries = []
    end

    context 'when sent one day ago' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, received_at: 1.day.ago) }

      before do
        job.perform(stored_mail)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 1 }
    end

    context 'when sent two days ago' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, received_at: 2.days.ago) }

      before do
        job.perform(stored_mail)
      end

      it { expect(ActionMailer::Base.deliveries.count).to eq 2 }
    end
  end
end
