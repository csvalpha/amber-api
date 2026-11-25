require 'rails_helper'

RSpec.describe V1::DeclarationResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }
  let(:content_fields) { %i[amount description purchase_date receipt missing_receipt_reason] }

  describe '#creatable_fields' do
    it { expect(described_class.creatable_fields(context)).to match_array(content_fields) }
  end

  describe '#updatable_fields' do
    it { expect(described_class.updatable_fields(context)).to match_array(content_fields) }

    context 'when with update permission' do
      let(:user) { create(:user, user_permission_list: ['declaration.update']) }

      it do
        expect(described_class.updatable_fields(context))
          .to match_array(content_fields + %i[include_in_next_collection])
      end
    end
  end

  describe '#fetchable_fields' do
    let(:resource) { described_class.new(create(:declaration), context) }

    it { expect(resource.fetchable_fields).not_to include(:receipt) }

    it do
      expect(resource.fetchable_fields)
        .to include(:paid_amount, :open_amount, :has_receipt, :status, :manually_paid_amount, :manually_paid_at)
    end
  end

  describe '#searchable_fields' do
    it { expect(described_class.searchable_fields).to eq %i[description] }
  end
end
