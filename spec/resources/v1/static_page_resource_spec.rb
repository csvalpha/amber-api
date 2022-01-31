require 'rails_helper'

RSpec.describe V1::StaticPageResource, type: :resource do
  let(:user) { create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }
  let(:record) { create(:static_page) }
  let(:resource) { described_class.new(record, context) }

  describe '#find_by_keys' do
    # rubocop:disable Rails/DynamicFindBy
    describe 'when existing' do
      context 'with id' do
        it { expect(described_class.find_by_key(record.id).id).to eq record.id }
      end

      context 'with slug' do
        it { expect(described_class.find_by_key(record.slug).id).to eq record.id }
      end
    end

    describe 'when not existing' do
      it do
        expect do
          described_class.find_by_key(record.id + 1).id
        end.to raise_error JSONAPI::Exceptions::RecordNotFound
      end
    end
    # rubocop:enable Rails/DynamicFindBy
  end
end
