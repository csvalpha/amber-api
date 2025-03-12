require 'rails_helper'

RSpec.describe RoomAdvert do
  subject(:room_advert) { build_stubbed(:room_advert) }

  describe '#valid' do
    it { expect(room_advert).to be_valid }

    context 'when without an author' do
      subject(:room_advert) { build_stubbed(:room_advert, author: nil) }

      it { expect(room_advert).not_to be_valid }
    end

    context 'when without a house_name' do
      subject(:room_advert) { build_stubbed(:room_advert, house_name: nil) }

      it { expect(room_advert).not_to be_valid }
    end

    context 'when without a contact' do
      subject(:room_advert) { build_stubbed(:room_advert, contact: nil) }

      it { expect(room_advert).not_to be_valid }
    end

    context 'when without a description' do
      subject(:room_advert) { build_stubbed(:room_advert, description: nil) }

      it { expect(room_advert).not_to be_valid }
    end

    context 'when without public visibility' do
      subject(:room_advert) { build_stubbed(:room_advert, publicly_visible: nil) }

      it { expect(room_advert).not_to be_valid }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo
  end

  describe '#publicly_visible' do
    before do
      create(:room_advert, publicly_visible: true)
      create(:room_advert, publicly_visible: true)
      create(:room_advert, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end
end
