require 'rails_helper'

RSpec.describe V1::Debit::CollectionResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: } }
  let(:collection) { create(:collection) }
  let(:resource) { described_class.new(collection, context) }

  describe '#creatable_fields' do
    it { expect(described_class.creatable_fields(context)).to match_array(%i[name date import_file]) }
  end

  describe '#fetchable_fields' do
    it { expect(resource.fetchable_fields).to include(:finalized_at, :pending_declaration_credits) }
    it { expect(resource.fetchable_fields).not_to include(:import_file) }
  end

  describe '#pending_declaration_credits' do
    let(:declaration) { create(:declaration, :approved, amount: 10) }

    before { create(:transaction, collection:, user: declaration.user, amount: 25) }

    it do
      expect(resource.pending_declaration_credits).to eq [{ declaration_id: declaration.id,
                                                            user_id: declaration.user_id,
                                                            description: declaration.description,
                                                            amount: 10 }]
    end
  end
end
