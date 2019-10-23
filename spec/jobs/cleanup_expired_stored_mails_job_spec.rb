require 'rails_helper'

RSpec.describe CleanupExpiredStoredMailsJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class.new }

    before do
      FactoryBot.create(:stored_mail)

      allow(job).to receive(:inform_slack).and_call_original
    end

    context 'when with no old emails' do
      before { job.perform }

      it { expect(job).to have_received(:inform_slack).with(0, 0) }
    end

    context 'when with one expired email and no deleted emails' do
      before do
        FactoryBot.create(:stored_mail, :expired)

        job.perform
      end

      it { expect(job).to have_received(:inform_slack).with(0, 1) }
    end

    context 'when with one deleted email and no expired emails' do
      before do
        FactoryBot.create(:stored_mail, :deleted)

        job.perform
      end

      it { expect(job).to have_received(:inform_slack).with(1, 0) }
    end

    context 'when with some deleted emails and expired emails' do
      before do
        FactoryBot.create(:stored_mail, :expired)
        FactoryBot.create_list(:stored_mail, 2, :deleted)

        job.perform
      end

      it { expect(job).to have_received(:inform_slack).with(2, 1) }
    end
  end
end
