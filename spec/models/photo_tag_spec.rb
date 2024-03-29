require 'rails_helper'

RSpec.describe PhotoTag, type: :model do
  subject(:photo_tag) { build(:photo_tag) }

  describe '#valid?' do
    it { expect(photo_tag).to be_valid }

    context 'when without an x position' do
      subject(:photo_tag) { build(:photo_tag, x: nil) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when without an y position' do
      subject(:photo_tag) { build(:photo_tag, y: nil) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when with a too large x position' do
      subject(:photo_tag) { build(:photo_tag, x: 101) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when with a too small x position' do
      subject(:photo_tag) { build(:photo_tag, x: -1) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when with a too large y position' do
      subject(:photo_tag) { build(:photo_tag, y: 101) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when with a too small y position' do
      subject(:photo_tag) { build(:photo_tag, y: -1) }

      it { expect(photo_tag).not_to be_valid }
    end

    context 'when with a valid x position' do
      subject(:photo_tag) { build(:photo_tag, x: 50) }

      it { expect(photo_tag).to be_valid }
    end

    context 'when with a valid y position' do
      subject(:photo_tag) { build(:photo_tag, y: 50) }

      it { expect(photo_tag).to be_valid }
    end
  end
end
