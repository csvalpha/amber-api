require 'rails_helper'

RSpec.describe Debit::Collection do
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
      let(:big_transaction) { create(:transaction, collection:, amount: 4500) }
      let(:small_transaction) { create(:transaction, collection:, amount: 400) }
      let(:medium_transaction) { create(:transaction, collection:, amount: 1500) }

      before do
        create(:mandate, user: big_transaction.user, iban: 'NL 44 RABO 0123456789')
        create(:mandate, user: small_transaction.user, iban: 'NL 39 ABNA 8234998285')
        create(:mandate, user: medium_transaction.user, iban: 'NL 69 ABNA4435376989')
      end

      it { expect(collection.to_sepa.first).to be_an_instance_of(SEPA::DirectDebit) }
      it { expect(collection.to_sepa.first.transactions.size).to eq 2 }
      it { expect(collection.to_sepa.first.transactions.first.amount).to eq 4500 }
      it { expect(collection.to_sepa.second.transactions.size).to eq 1 }
      it { expect(collection.to_sepa.second.transactions.first.amount).to eq 1500 }
    end

    context 'when collection date has passed' do
      let(:collection) { create(:collection, date: 0.days.ago) }

      before { collection.to_sepa }

      it { expect(collection.to_sepa).to be_nil }

      it do
        expect(collection.errors.messages[:sepa].first).to eq 'can only generate sepa files ' \
                                                              'for collections in future'
      end
    end
  end

  describe '.current' do
    let!(:latest) { create(:collection, date: 2.months.from_now) }

    before do
      create(:collection, date: 1.month.from_now)
      create(:collection, date: 3.months.from_now, finalized_at: Time.zone.now)
    end

    it { expect(described_class.current).to eq latest }
    it { expect(latest).to be_current }
    it { expect(described_class.where.not(id: latest.id).none?(&:current?)).to be true }
  end

  describe 'declaration settlement' do
    let(:collection) { create(:collection) }
    let(:user) { create(:user) }
    let!(:declaration) { create(:declaration, :approved, user:, amount: 30) }

    before { create(:mandate, user:) }

    context 'when the user owes more than the declaration' do
      before { create(:transaction, collection:, user:, amount: 50) }

      it { expect(collection.pending_declaration_credits).to eq [{ declaration:, amount: 30 }] }

      it 'settles the declaration completely' do
        collection.finalize!
        expect(declaration.reload).to be_paid
      end

      it { expect { collection.finalize! }.to(change(collection, :total_transaction_amount).from(50).to(20)) }
      it { expect { collection.finalize! }.to(change { collection.reload.finalized_at }.from(nil)) }
    end

    context 'when the user owes less than the declaration' do
      before do
        create(:transaction, collection:, user:, amount: 10)
        create(:transaction, collection:, user: create(:mandate).user, amount: 5)
        collection.finalize!
      end

      it { expect(declaration.reload).to be_partially_paid }
      it { expect(declaration.open_amount).to eq 20 }
      it { expect(collection.transactions.where(user:).sum(:amount)).to eq 0 }
      it { expect(collection.reload).to be_finalized }

      it 'carries the rest over to the next collection' do
        next_collection = create(:collection)
        create(:transaction, collection: next_collection, user:, amount: 40)
        expect(next_collection.pending_declaration_credits).to eq [{ declaration:, amount: 20 }]
      end
    end

    context 'when the user has multiple declarations' do
      let!(:older) { create(:declaration, :approved, user:, amount: 15, approved_at: 2.days.ago) }

      before do
        declaration
        create(:transaction, collection:, user:, amount: 20)
      end

      it 'settles the oldest declaration first' do
        expect(collection.pending_declaration_credits).to eq [{ declaration: older, amount: 15 },
                                                              { declaration:, amount: 5 }]
      end
    end

    context 'when the declaration is paid manually after the credits were calculated' do
      before do
        create(:transaction, collection:, user:, amount: 50)
        credits = collection.pending_declaration_credits
        allow(collection).to receive(:pending_declaration_credits).and_return(credits)
        declaration.mark_manually_paid!(create(:user))
        collection.finalize!
      end

      it { expect(collection.transactions.where.not(declaration_id: nil)).to be_empty }
      it { expect(declaration.reload.paid_amount).to eq 30 }
      it { expect(collection.reload).to be_finalized }
    end

    context 'when the declaration is not included in the next collection' do
      before do
        declaration.update!(include_in_next_collection: false)
        create(:transaction, collection:, user:, amount: 50)
      end

      it { expect(collection.pending_declaration_credits).to be_empty }
    end

    context 'when the user has nothing to pay on this collection' do
      before do
        declaration
        create(:transaction, collection:, amount: 50, user: create(:mandate).user)
      end

      it { expect(collection.pending_declaration_credits).to be_empty }
    end

    context 'when the collection is not the current one' do
      before do
        create(:transaction, collection:, user:, amount: 50)
        declaration
        create(:collection, date: collection.date + 1.day)
      end

      it { expect(collection.pending_declaration_credits).to be_empty }
    end

    context 'when the sepa cannot be generated' do
      before do
        declaration
        create(:transaction, collection:, user:, amount: 50)
        create(:transaction, collection:, amount: 10) # user without mandate
      end

      it { expect(collection.finalize!).to be false }
      it { expect { collection.finalize! }.not_to(change { collection.transactions.count }) }

      it 'rolls back the settlement' do
        collection.finalize!
        expect(declaration.reload).to be_approved
      end

      it 'keeps the collection open' do
        collection.finalize!
        expect(collection.reload).not_to be_finalized
      end
    end

    context 'when the collection date has passed' do
      let(:collection) { create(:collection, date: 1.day.ago) }

      before { create(:transaction, collection:, user:, amount: 50) }

      it { expect(collection.finalize!).to be false }
    end

    context 'when the user ends at exactly zero' do
      before do
        create(:transaction, collection:, user:, amount: 30)
        create(:transaction, collection:, user: create(:mandate).user, amount: 10)
        collection.finalize!
      end

      it { expect(declaration.reload).to be_paid }
      it { expect(collection.to_sepa.first.transactions.size).to eq 1 }
    end

    context 'when only users at zero remain' do
      before { create(:transaction, collection:, user:, amount: 30) }

      it { expect(collection.finalize!).to be false }

      it do
        collection.finalize!
        expect(collection.errors[:sepa]).to include 'bevat geen transacties'
      end
    end

    context 'when already finalized' do
      let(:collection) { create(:collection, finalized_at: Time.zone.now) }

      it { expect(collection.finalize!).to be false }
    end
  end
end
