require 'rails_helper'

RSpec.describe V1::BoardRoomPresenceResource, type: :resource do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { user: user } }
  let(:options) { { context: context } }

  describe 'filters' do
    let(:filtered) { described_class.apply_filters(BoardRoomPresence, filter, options) }

    describe 'current' do
      let(:filter) { { current: true } }
      let(:record) { FactoryBot.create(:board_room_presence) }

      before do
        record
        FactoryBot.create(:board_room_presence, :future)
      end

      it { expect(filtered.first.id).to eq record.id }
      it { expect(filtered.size).to eq 1 }
    end

    describe 'future' do
      let(:filter) { { future: true } }
      let(:record) { FactoryBot.create(:board_room_presence, :future) }

      before do
        record
        FactoryBot.create(:board_room_presence)
      end

      it { expect(filtered.first.id).to eq record.id }
      it { expect(filtered.size).to eq 1 }
    end

    describe 'current_and_future' do
      let(:filter) { { current_and_future: true } }

      before do
        FactoryBot.create(:board_room_presence, :future)
        FactoryBot.create(:board_room_presence, :history)
        FactoryBot.create(:board_room_presence)
      end

      it { expect(filtered.size).to eq 2 }
    end
  end
end
