require 'rails_helper'

RSpec.describe CollectionImportJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:collection) { create(:collection) }
    let(:test_file) { Rails.root.join('spec', 'support', 'files', 'collection_import.csv') }
    let(:encoded_file) { Base64.strict_encode64(File.read(test_file)) }
    let(:base64_data) { "data:text/csv;base64,#{encoded_file}" }
    let(:transaction_user) { create(:user, username: 'bestuurder') }
    let(:mail) { ActionMailer::Base.deliveries.first }

    subject(:job) do
      perform_enqueued_jobs do
        described_class.perform_now(base64_data, collection, user)
      end
    end

    before do
      ActionMailer::Base.deliveries = []
      transaction_user
      user
      job
    end

    context 'when with valid file' do
      it { expect(collection.reload.transactions.size).to eq 6 }
      it { expect(mail.body.to_s).to include('is gelukt!') }
      it { expect(mail.body.to_s).to include('112.23') }
    end

    context 'when with malformed file' do
      let(:test_file) do
        Rails.root.join('spec', 'support', 'files', 'malformed_collection_import.csv')
      end

      it { expect(collection.reload.transactions.size).to eq 0 }
      it { expect(mail.body.to_s).to include('is mislukt!') }
    end
  end
end
