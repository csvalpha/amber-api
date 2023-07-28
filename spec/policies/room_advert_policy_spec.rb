require 'rails_helper'

RSpec.describe RoomAdvertPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when room_advert is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:room_advert)) }
    end

    describe 'when room_advert is owned' do
      it { expect(policy).to permit(user, build_stubbed(:room_advert, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'room_advert.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:room_advert)) }
    end
  end

end
