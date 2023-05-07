require 'rails_helper'

RSpec.describe GroupPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:group) { build(:group) }

  permissions :update? do
    let(:record_permission) { 'group.update' }
    let(:user) { create(:user) }

    describe 'when user is not a member' do
      it { expect(policy).not_to permit(user, group) }
    end

    describe 'when user is a member' do
      let(:user) { create(:user, groups: [group]) }

      it { expect(policy).to permit(user, group) }
    end

    describe 'when user is no longer a member' do
      before do
        create(:membership, user:, group:, end_date: Date.yesterday)
      end

      it { expect(policy).not_to permit(user, group) }
    end

    describe 'when user is a future member' do
      before do
        create(:membership, user:, group:, start_date: Date.tomorrow)
      end

      it { expect(policy).not_to permit(user, group) }
    end

    describe 'when user is a member with membership ending in future' do
      before do
        create(:membership, user:, group:, end_date: Date.tomorrow)
      end

      it { expect(policy).to permit(user, group) }
    end

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, group) }
    end
  end

  describe '#create_with_permissions?' do
    it { expect(policy.new(nil, nil).create_with_permissions?(nil)).to be true }
  end

  describe '#replace_permissions?' do
    it { expect(policy.new(nil, nil).replace_permissions?(nil)).to be true }
  end
end
