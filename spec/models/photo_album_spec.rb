require 'rails_helper'

RSpec.describe PhotoAlbum, type: :model do
  subject(:photo_album) { FactoryBot.build_stubbed(:photo_album) }

  describe '#valid?' do
    it { expect(photo_album.valid?).to be true }

    context 'when without an title' do
      subject(:photo_album) { FactoryBot.build_stubbed(:photo_album, title: nil) }

      it { expect(photo_album.valid?).to be false }
    end

    context 'when without an author' do
      subject(:photo_album) { FactoryBot.build_stubbed(:photo_album, author: nil) }

      it { expect(photo_album.valid?).to be false }
    end

    context 'when without public visibility' do
      subject(:photo_album) { FactoryBot.build_stubbed(:photo_album, publicly_visible: nil) }

      it { expect(photo_album).not_to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#publicly_visible' do
    before do
      FactoryBot.create(:photo_album, publicly_visible: true)
      FactoryBot.create(:photo_album, publicly_visible: true)
      FactoryBot.create(:photo_album, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end

  describe '#to_zip' do
    subject(:photo_album) { FactoryBot.create(:photo_album) }

    before do
      photo_album
      FactoryBot.create(:photo, photo_album: photo_album)
    end

    it { expect(photo_album.to_zip).not_to be nil }
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :photo
  end
end
