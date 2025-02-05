require 'rails_helper'

RSpec.describe Debit::Collection, type: :model do
  subject(:collection) { build_stubbed(:collection) }

  describe '#valid' do
    it { expect(collection).to be_valid }

    context 'when without a name' do
      subject(:collection) { build_stubbed(:collection, name: nil) }

      it { expect(collection).not_to be_valid }
    end

    context 'when without a date' do
      subject(:collection) { build_stubbed(:collection, date: nil) }

      it { expect(collection).not_to be_valid }
    end

    context 'when without an author' do
      subject(:collection) { build_stubbed(:collection, author: nil) }

      it { expect(collection).not_to be_valid }
    end
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :transaction
  end

  describe '#total_transaction_amount' do
    let(:transaction) { create(:transaction) }
    let(:another_transaction) do
      create(:transaction, collection: transaction.collection)
    end
    let(:collection) { transaction.collection }
    let(:total_transaction_amount) { transaction.amount + another_transaction.amount }

    before { another_transaction }

    it { expect(collection.total_transaction_amount).to eq total_transaction_amount }
  end

  describe '#to_sepa' do
    context 'when with user without mandate' do
      context 'when user has amount to be collected' do
        before do
          create(:transaction, collection:)
          collection.to_sepa
        end

        it { expect(collection.to_sepa).to be_empty }

        it do
          expect(
            collection.errors.messages[:sepa].first
          ).to include "doesn't have an active mandate."
        end
      end

      context 'when user has zero amount' do
        before do
          create(:transaction, collection:, amount: 0)
          collection.to_sepa
        end

        it { expect(collection.to_sepa).to be_empty }

        it do
          expect(collection.errors).to be_empty
        end
      end
    end

    context 'when user has zero amount in collection' do
      let(:transaction) { create(:transaction, collection:, amount: 2) }

      before do
        create(:transaction, collection:, user: transaction.user, amount: -2)
        create(:mandate, user: transaction.user)
      end

      it { expect(collection.to_sepa.first).to be_nil }
    end

    context 'when user has negative amount in collection' do
      let(:transaction) { create(:transaction, collection:, amount: -2) }

      before do
        create(:mandate, user: transaction.user)
        collection.to_sepa
      end

      it { expect(collection.to_sepa).to be_empty }

      it do
        expect(
          collection.errors.messages[:sepa].first
        ).to include 'has a negative collection amount'
      end
    end

    context 'when user has mandate and amount' do
      let(:transaction1) { create(:transaction, collection:, amount: 3000) }
      let(:transaction2) { create(:transaction, collection:, amount: 100) }
      let(:transaction3) { create(:transaction, collection:, amount: 3000) }

      before do
        create(:mandate, user: transaction1.user, iban: 'NL 44 RABO 0123456789')
        create(:mandate, user: transaction2.user, iban: 'NL 39 ABNA 8234998285')
        create(:mandate, user: transaction3.user, iban: 'NL 69 ABNA4435376989')
      end

      it { expect(collection.to_sepa.first).to be_an_instance_of(SEPA::DirectDebit) }
      it { expect(collection.to_sepa.first.transactions.size).to eq 2 }
      it { expect(collection.to_sepa.first.transactions.first.amount).to eq 3000 }
      it { expect(collection.to_sepa.second.transactions.size).to eq 1 }
      it { expect(collection.to_sepa.second.transactions.first.amount).to eq 3000 }
    end

    context 'when collection date has passed' do
      let(:collection) { create(:collection, date: 0.days.ago) }

      before { collection.to_sepa }

      it { expect(collection.to_sepa).to be_nil }

      it do
        expect(collection.errors.messages[:sepa].first).to eq 'can only generate sepa files'\
                                                              ' for collections in future'
      end
    end
  end
end
