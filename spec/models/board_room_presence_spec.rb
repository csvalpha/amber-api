require 'rails_helper'

RSpec.describe BoardRoomPresence, type: :model do
  subject(:board_room_presence) { FactoryBot.build_stubbed(:board_room_presence) }

  describe '#valid?' do
    it { expect(board_room_presence).to be_valid }

    context 'when without start time' do
      subject(:board_room_presence) do
        FactoryBot.build_stubbed(:board_room_presence, start_time: nil)
      end

      it { expect(board_room_presence).not_to be_valid }
    end

    context 'when without end time' do
      subject(:board_room_presence) do
        FactoryBot.build_stubbed(:board_room_presence, end_time: nil)
      end

      it { expect(board_room_presence).not_to be_valid }
    end

    context 'when end time before start time' do
      subject(:board_room_presence) do
        FactoryBot.build_stubbed(:board_room_presence,
                                 end_time: 1.day.ago, start_time: 1.day.from_now)
      end

      it { expect(board_room_presence).not_to be_valid }
    end

    context 'when without status' do
      subject(:board_room_presence) { FactoryBot.build_stubbed(:board_room_presence, status: nil) }

      it { expect(board_room_presence).not_to be_valid }
    end

    context 'when without a user' do
      subject(:board_room_presence) { FactoryBot.build_stubbed(:board_room_presence, user: nil) }

      it { expect(board_room_presence).not_to be_valid }
    end
  end

  describe '#current' do
    context 'when started in the past and ended in the future' do
      before { FactoryBot.create(:board_room_presence) }

      it { expect(BoardRoomPresence.current.count).to eq 1 }
    end

    context 'when not yet started' do
      before { FactoryBot.create(:board_room_presence, start_time: 1.minute.from_now) }

      it { expect(BoardRoomPresence.current.count).to eq 0 }
    end

    context 'when just ended' do
      before { FactoryBot.create(:board_room_presence, end_time: 1.second.ago) }

      it { expect(BoardRoomPresence.current.count).to eq 0 }
    end
  end

  describe '#future' do
    context 'when started in the past and ended in the future' do
      before { FactoryBot.create(:board_room_presence) }

      it { expect(BoardRoomPresence.future.count).to eq 0 }
    end

    context 'when not yet started' do
      before { FactoryBot.create(:board_room_presence, start_time: 1.minute.from_now) }

      it { expect(BoardRoomPresence.future.count).to eq 1 }
    end

    context 'when just ended' do
      before { FactoryBot.create(:board_room_presence, end_time: 1.second.ago) }

      it { expect(BoardRoomPresence.future.count).to eq 0 }
    end
  end

  describe '#current_and_future' do
    context 'when started in the past and ended in the future' do
      before { FactoryBot.create(:board_room_presence) }

      it { expect(BoardRoomPresence.current_and_future.count).to eq 1 }
    end

    context 'when not yet started' do
      before { FactoryBot.create(:board_room_presence, start_time: 1.minute.from_now) }

      it { expect(BoardRoomPresence.current_and_future.count).to eq 1 }
    end

    context 'when just ended' do
      before { FactoryBot.create(:board_room_presence, end_time: 1.second.ago) }

      it { expect(BoardRoomPresence.current_and_future.count).to eq 0 }
    end

    context 'when starting in the future' do
      before { FactoryBot.create(:board_room_presence, start_time: 1.second.from_now) }

      it { expect(BoardRoomPresence.current_and_future.count).to eq 1 }
    end
  end
end
