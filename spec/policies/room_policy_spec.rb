require 'rails_helper'

RSpec.describe RoomPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when room is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:room)) }
    end

    describe 'when room is owned' do
      it { expect(policy).to permit(user, build_stubbed(:room, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'room.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:room)) }
    end
  end

end
