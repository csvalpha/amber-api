require 'rails_helper'

RSpec.describe PhotoAlbum do
  subject(:photo_album) { build_stubbed(:photo_album) }

  describe '#valid?' do
    it { expect(photo_album.valid?).to be true }

    context 'when without an title' do
      subject(:photo_album) { build_stubbed(:photo_album, title: nil) }

      it { expect(photo_album.valid?).to be false }
    end

    context 'when without an author' do
      subject(:photo_album) { build_stubbed(:photo_album, author: nil) }

      it { expect(photo_album.valid?).to be false }
    end

    context 'when without public visibility' do
      subject(:photo_album) { build_stubbed(:photo_album, visibility: 'members') }

      it { expect(photo_album).not_to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#visibility' do
    before do
      create(:photo_album, visibility: 'public')
      create(:photo_album, visibility: 'alumni')
      create(:photo_album, visibility: 'members')
    end

    it { expect(described_class.where(visibility: %w[public]).count).to be 1 }
    it { expect(described_class.where(visibility: %w[alumni public]).count).to be 2 }
    it { expect(described_class.count - described_class..where(visibility: %w[alumni public]).count).to be 1 }
  end

  describe '#to_zip' do
    subject(:photo_album) { create(:photo_album) }

    before do
      photo_album
      create(:photo, photo_album:)
    end

    it { expect(photo_album.to_zip).not_to be_nil }
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :photo
  end
end
