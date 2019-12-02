require 'rails_helper'

RSpec.describe CleanupExpiredStoredMailsJob, type: :job do
  describe '#perform' do
    let(:stored_mail) { FactoryBot.create(:stored_mail) }

    subject(:job) { described_class.new }

    before do
      stored_mail

      # Set up spy for #inform_slack
      allow(job).to receive(:inform_slack)
      job.perform
    end

    context 'when with no old emails' do
      it { expect(StoredMail.count).to be(1) }
      it { expect(job).to have_received(:inform_slack).with(0, 0) }
    end

    context 'when with one expired email and no deleted emails' do
      let(:stored_mail){ FactoryBot.create(:stored_mail, :expired)}

      it { expect(StoredMail.only_deleted.count).to eq 1}
      it { expect(job).to have_received(:inform_slack).with(0, 1) }
    end

    context 'when with one deleted email and no expired emails' do
      let(:stored_mail) { FactoryBot.create(:stored_mail, :deleted)}

      it { expect(StoredMail.only_deleted.count).to eq 0}
      it { expect(job).to have_received(:inform_slack).with(1, 0) }
    end

    context 'when with both deleted emails and expired emails' do
      let(:stored_mail) {  FactoryBot.create_list(:stored_mail, 2, :deleted) + [FactoryBot.create(:stored_mail, :expired)] }

      it { expect(job).to have_received(:inform_slack).with(2, 1) }
    end
  end
end
