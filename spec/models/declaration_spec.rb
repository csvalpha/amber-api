require 'rails_helper'

RSpec.describe Declaration do
  subject(:declaration) { build(:declaration) }

  describe '#valid?' do
    it { expect(declaration).to be_valid }
    it { expect(build(:declaration, :with_receipt)).to be_valid }

    context 'when without an amount' do
      subject(:declaration) { build(:declaration, amount: nil) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when with a zero amount' do
      subject(:declaration) { build(:declaration, amount: 0) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when without a description' do
      subject(:declaration) { build(:declaration, description: nil) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when without a purchase date' do
      subject(:declaration) { build(:declaration, purchase_date: nil) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when with a purchase date in the future' do
      subject(:declaration) { build(:declaration, purchase_date: 1.day.from_now) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when without a receipt and without a reason' do
      subject(:declaration) { build(:declaration, missing_receipt_reason: nil) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when with a receipt and a reason' do
      subject(:declaration) { build(:declaration, :with_receipt, missing_receipt_reason: 'kwijt') }

      it { expect(declaration).not_to be_valid }
    end

    context 'when rejected without a reason' do
      subject(:declaration) { build(:declaration, :rejected, rejection_reason: nil) }

      it { expect(declaration).not_to be_valid }
    end

    context 'when with an unknown status' do
      subject(:declaration) { build(:declaration, status: 'unknown') }

      it { expect(declaration).not_to be_valid }
    end
  end

  describe 'settled declarations' do
    let(:declaration) { create(:declaration, :approved, amount: 30) }

    before do
      create(:transaction, declaration:, user: declaration.user, amount: -10)
      declaration.update!(status: :partially_paid)
    end

    it { expect(declaration.paid_amount).to eq 10 }
    it { expect(declaration.open_amount).to eq 20 }
    it { expect(declaration.update(include_in_next_collection: false)).to be true }
    it { expect(declaration.update(description: 'Iets anders')).to be false }

    context 'when lowering the amount below the paid amount' do
      before { declaration.update_column(:status, 'approved') } # rubocop:disable Rails/SkipsModelValidations

      it { expect(declaration.update(amount: 5)).to be false }
    end
  end

  describe '.settleable' do
    let(:approved) { create(:declaration, :approved) }
    let(:partially_paid) { create(:declaration, :approved, status: :partially_paid) }

    before do
      create(:declaration)
      create(:declaration, :approved, include_in_next_collection: false)
      create(:declaration, :rejected)
    end

    it { expect(described_class.settleable).to contain_exactly(approved, partially_paid) }
  end

  describe '#approve!' do
    let(:declaration) { create(:declaration) }
    let(:approver) { create(:user) }

    context 'when the user has an active mandate' do
      before do
        create(:mandate, user: declaration.user)
        declaration.approve!(approver)
      end

      it { expect(declaration).to be_approved }
      it { expect(declaration.approved_by).to eq approver }
      it { expect(declaration.approved_at).to be_present }
      it { expect(declaration.include_in_next_collection).to be true }
    end

    context 'when the user has no active mandate' do
      it { expect(declaration.approve!(approver)).to be false }

      it do
        declaration.approve!(approver)
        expect(declaration.errors[:user]).to be_present
      end
    end
  end

  describe '#mark_manually_paid!' do
    let(:declaration) { create(:declaration, :approved, amount: 30) }
    let(:payer) { create(:user) }

    before do
      create(:transaction, declaration:, user: declaration.user, amount: -10)
      declaration.update!(status: :partially_paid)
      declaration.mark_manually_paid!(payer)
    end

    it { expect(declaration).to be_paid }
    it { expect(declaration.manually_paid_amount).to eq 20 }
    it { expect(declaration.paid_amount).to eq 30 }
    it { expect(declaration.open_amount).to eq 0 }
    it { expect(declaration.manually_paid_by).to eq payer }
    it { expect(declaration.manually_paid_at).to be_present }
    it { expect(declaration.include_in_next_collection).to be false }
  end

  describe '#reject!' do
    let(:declaration) { create(:declaration) }

    it { expect(declaration.reject!('Geen geldige bon')).to be true }
    it { expect(declaration.reject!(nil)).to be false }
  end

  describe 'pdf upload' do
    let(:declaration) { create(:declaration, :approved) }

    before { declaration }

    it { expect { create(:declaration, :approved) }.to have_enqueued_job(DeclarationPdfJob) }
    it { expect { create(:declaration) }.not_to have_enqueued_job(DeclarationPdfJob) }
    it { expect { declaration.update!(amount: 12) }.to have_enqueued_job(DeclarationPdfJob) }
    it { expect { declaration.update!(include_in_next_collection: false) }.not_to have_enqueued_job(DeclarationPdfJob) }
  end
end
