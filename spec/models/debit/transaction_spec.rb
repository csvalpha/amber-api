require 'rails_helper'

RSpec.describe Debit::Transaction, type: :model do
  subject(:transaction) { FactoryBot.create(:transaction) }

  describe '#valid' do
    it { expect(transaction).to be_valid }

    context 'when without a description' do
      subject(:transaction) { FactoryBot.build_stubbed(:transaction, description: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a amount' do
      subject(:transaction) { FactoryBot.build_stubbed(:transaction, amount: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a collection' do
      subject(:transaction) { FactoryBot.build_stubbed(:transaction, collection: nil) }

      it { expect(transaction).not_to be_valid }
    end

    context 'when without a user' do
      subject(:transaction) { FactoryBot.build_stubbed(:transaction, user: nil) }

      it { expect(transaction).not_to be_valid }
    end
  end

  describe '.transactions_for' do
    context 'when transaction is for user' do
      let(:scoped) { described_class.transactions_for(transaction.user) }

      it { expect(scoped).to contain_exactly(transaction) }
    end

    context 'when transaciton is for another user' do
      let(:user) { FactoryBot.create(:user) }
      let(:scoped) { described_class.transactions_for(user) }

      it { expect(scoped).to be_empty }
    end
  end
end
