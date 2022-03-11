require 'rails_helper'

RSpec.describe BookPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :isbn_lookup? do
    describe 'when cannot create or edit book' do
      it { expect(policy).not_to permit(user, build_stubbed(:book)) }
    end

    describe 'when can create book' do
      let(:record_permission) { 'book.create' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:book)) }
    end

    describe 'when can update book' do
      let(:record_permission) { 'book.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:book)) }
    end
  end
end
