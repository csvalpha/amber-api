require 'rails_helper'

RSpec.describe V1::ApplicationResource, type: :resource do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }
  let(:other_user) do
    create(:user, first_name: 'John', last_name_prefix: 'de', last_name: 'Vries')
  end
  let(:context) { { user: } }
  let(:options) { { context: } }

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(User, filter, options) }

    before do
      allow(described_class).to receive(:searchable_fields).and_return(%i[first_name last_name])
      user
      other_user
    end

    describe 'search' do
      context 'when searching for one record' do
        let(:filter) { { search: %w[john doe] } }

        it { expect(filtered).to eq [user] }
        it { expect(filtered.size).to eq 1 }
      end

      context 'when searching for multiple records' do
        let(:filter) { { search: ['john'] } }

        it { expect(filtered).to include user }
        it { expect(filtered).to include other_user }
        it { expect(filtered.size).to eq 2 }
      end

      context 'when without records' do
        let(:filter) { { search: ['jan'] } }
        let(:filtered) { described_class.apply_filters([], filter, options) }

        it { expect(filtered).to eq [] }
      end
    end
  end
end
