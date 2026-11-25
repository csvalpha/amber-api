require 'rails_helper'

RSpec.describe Debit::Transaction do
  subject(:transaction) { create(:transaction) }

  describe '#valid' do
    it { expect(transaction).to be_valid }

    context 'when without a description' do
      subject(:transaction) { build_stubbed(:transaction, description: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a amount' do
      subject(:transaction) { build_stubbed(:transaction, amount: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a collection' do
      subject(:transaction) { build_stubbed(:transaction, collection: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a user' do
      subject(:transaction) { build_stubbed(:transaction, user: nil) }

      it { expect(transaction).not_to be_valid }
    end
  end

  describe 'on a finalized collection' do
    let(:finalized) { create(:collection) }
    let(:open_collection) { create(:collection) }
    let!(:locked_transaction) { create(:transaction, collection: finalized) }

    before { finalized.update!(finalized_at: Time.zone.now) }

    it { expect(build(:transaction, collection: finalized)).not_to be_valid }
    it { expect(locked_transaction.update(amount: 1)).to be false }
    it { expect(locked_transaction.update(collection: open_collection)).to be false }
    it { expect(create(:transaction, collection: open_collection).update(collection: finalized)).to be false }
    it { expect(locked_transaction.destroy).to be false }
    it { expect(create(:transaction, collection: open_collection).destroy).to be_truthy }

    it 'checks the persisted collection when the association was reassigned without saving' do
      locked_transaction.collection = open_collection
      expect(locked_transaction.destroy).to be false
    end

    context 'when a stale instance changes a transaction that was moved to a finalized collection' do
      let(:transaction) { create(:transaction, collection: open_collection) }
      let(:stale) { described_class.find(transaction.id) }
      let(:other_collection) { create(:collection) }

      before do
        stale
        transaction.update!(collection: other_collection)
        other_collection.update!(finalized_at: Time.zone.now)
      end

      it { expect(stale.update(amount: 1)).to be false }
      it { expect(stale.destroy).to be false }
    end

    it 'still updates a transaction when both collections are open' do
      transaction = create(:transaction, collection: open_collection)
      expect(transaction.update(collection: create(:collection), amount: 1)).to be true
    end
  end

  describe '.transactions_for' do
    context 'when transaction is for user' do
      let(:scoped) { described_class.transactions_for(transaction.user) }

      it { expect(scoped).to contain_exactly(transaction) }
    end

    context 'when transaciton is for another user' do
      let(:user) { create(:user) }
      let(:scoped) { described_class.transactions_for(user) }

      it { expect(scoped).to be_empty }
    end
  end
end
