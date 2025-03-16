require 'rails_helper'

RSpec.describe PhotoComment do
  subject(:photo_comment) { build(:photo_comment) }

  describe '#valid?' do
    it { expect(photo_comment).to be_valid }

    context 'when with an empty content' do
      subject(:photo_comment) { build(:photo_comment, content: '') }

      it { expect(photo_comment).not_to be_valid }
    end

    context 'when with a too long content' do
      subject(:photo_comment) do
        build(:photo_comment, content: Faker::Lorem.characters(number: 501))
      end

      it { expect(photo_comment).not_to be_valid }
    end

    context 'when without a photo' do
      subject(:photo_comment) { build(:photo_comment, photo: nil) }

      it { expect(photo_comment).not_to be_valid }
    end

    context 'when without an author' do
      subject(:photo_comment) { build(:photo_comment, author: nil) }

      it { expect(photo_comment).not_to be_valid }
    end
  end

  describe '#visibilty' do
    before do
      create(:photo_comment, photo_album: alumni_album)
      create(:photo_comment, photo_album: alumni_album)
      create(:photo_comment, photo_album: private_album)
    end

    it {
      expect(described_class.joins(:photo_album).where(photo_album: { visibility: 'alumni' }).count).to be 2
    }

    it {
      expect(described_class.count - described_class.joins(:photo_album)
                                                      .where(photo_album: { visibility: 'alumni' }).count).to be 1
    }
  end
end
