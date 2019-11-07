require 'rails_helper'

RSpec.describe CleanupExpiredStoredMailsJob, type: :job do
  describe '#perform' do
    let(:valid_stored_mail) { FactoryBot.create(:stored_mail) }

    subject(:job) { described_class.new }

    before do
      valid_stored_mail

      # Set up spy for #inform_slack
      allow(job).to receive(:inform_slack).and_call_original
    end

    context 'when with no old emails' do
      before { job.perform }

      it { expect(StoredMail.count).to be(1) }
      it { expect(job).to have_received(:inform_slack).with(0, 0) }
    end

    context 'when with one expired email and no deleted emails' do
      before do
        FactoryBot.create(:stored_mail, :expired)
      end

      it { expect { job.perform }.to change { StoredMail.only_deleted.count }.from(0).to(1) }

      describe 'calls #inform_slack with the right arguments' do
        before { job.perform }

        it { expect(job).to have_received(:inform_slack).with(0, 1) }
      end
    end

    context 'when with one deleted email and no expired emails' do
      before do
        FactoryBot.create(:stored_mail, :deleted)
      end

      it { expect { job.perform }.to change { StoredMail.only_deleted.count }.from(1).to(0) }

      describe 'calls #inform_slack with the right arguments' do
        before { job.perform }

        it { expect(job).to have_received(:inform_slack).with(1, 0) }
      end
    end

    context 'when with both deleted emails and expired emails' do
      before do
        FactoryBot.create(:stored_mail, :expired)
        FactoryBot.create_list(:stored_mail, 2, :deleted)

        job.perform
      end

      it { expect(job).to have_received(:inform_slack).with(2, 1) }
    end
  end
end
