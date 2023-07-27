require 'rails_helper'

RSpec.describe Room, type: :model do
  subject(:room) { build_stubbed(:room) }

  describe '#valid' do
    it { expect(room).to be_valid }

    context 'when without an author' do
      subject(:room) { build_stubbed(:room, author: nil) }

      it { expect(room).not_to be_valid }
    end

    context 'when without a house_name' do
      subject(:room) { build_stubbed(:room, house_name: nil) }

      it { expect(room).not_to be_valid }
    end

    context 'when without a contact' do
      subject(:room) { build_stubbed(:room, contact: nil) }

      it { expect(room).not_to be_valid }
    end

    context 'when without a description' do
      subject(:room) { build_stubbed(:room, description: nil) }

      it { expect(room).not_to be_valid }
    end

    context 'when without public visibility' do
      subject(:room) { build_stubbed(:room, publicly_visible: nil) }
  
      it { expect(room).not_to be_valid }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo
  end

  describe '#publicly_visible' do
    before do
      create(:room, publicly_visible: true)
      create(:room, publicly_visible: true)
      create(:room, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end
end
