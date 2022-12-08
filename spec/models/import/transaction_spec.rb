require 'rails_helper'

RSpec.describe Import::Transaction, type: :model do
  let(:user) { create(:user, username: 'bestuurder') }
  let(:test_file) { Rails.root.join('spec', 'support', 'files', 'collection_import.csv') }
  let(:collection) { create(:collection) }
  let(:importer) { described_class.new({ file: test_file, extension: 'csv' }, collection) }
  let(:errors) { collection.errors.messages[:import_file] }

  before do
    user
    importer.import!
    collection.reload
  end

  describe 'when importing' do
    context 'when with correct file' do
      let(:negative_transaction) { Debit::Transaction.find_by(description: 'Voorschot Zeilweek') }
      let(:transaction) { Debit::Transaction.find_by(description: 'Zeilweek') }
      let(:zero_transaction) { Debit::Transaction.find_by(description: 'Gratis Activiteit') }
      let(:comma_transaction) { Debit::Transaction.find_by(description: 'Komma') }
      let(:comma_seperated) { Debit::Transaction.find_by(description: 'Komma Seperated') }

      it { expect { importer.import! }.not_to raise_error }
      it { expect(collection.errors.size).to eq 0 }
      it { expect(collection.transactions.length).to eq 6 }
      it { expect(negative_transaction.amount).to eq(-100) }
      it { expect(transaction.amount).to eq 212.5 }
      it { expect(zero_transaction).to be_nil }
      it { expect(comma_transaction).to be_nil }
      it { expect(comma_seperated.amount).to eq 2.55 }
    end

    context 'when with incorrect user' do
      let(:test_file) do
        Rails.root.join('spec', 'support', 'files',
                        'collection_import_with_incorrect_user.csv')
      end

      it { expect { importer.import! }.not_to raise_error }
      it { expect(collection.errors.size).to eq 1 }

      it do
        expect(errors.first).to eq 'User non-existing not found'
      end
    end

    context 'when with incorrect csv' do
      let(:test_file) do
        Rails.root.join('spec', 'support', 'files',
                        'malformed_collection_import.csv')
      end

      it { expect { importer.import! }.not_to raise_error }

      it {
        expect(errors.first).to eq 'username field must be present'
      }
    end

    context 'when with incorrect transactions in csv' do
      let(:test_file) do
        Rails.root.join('spec', 'support', 'files',
                        'collection_import_with_incorrect_transactions.csv')
      end

      it { expect { importer.import! }.not_to raise_error }
      it { expect(errors.size).to eq 2 }

      it {
        expect(errors.first).to eq 'Transaction Slot BBQ for user bestuurder has an invalid amount'
      }

      it {
        expect(errors.second).to eq 'Transaction  for user bestuurder is invalid'
      }
    end
  end
end
