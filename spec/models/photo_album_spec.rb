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
      subject(:photo_album) { build_stubbed(:photo_album, publicly_visible: nil) }

      it { expect(photo_album).not_to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#publicly_visible' do
    before do
      create(:photo_album, publicly_visible: true)
      create(:photo_album, publicly_visible: true)
      create(:photo_album, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end

  describe '#without_photo_tags' do
    subject(:albums) { described_class.without_photo_tags }

    let!(:empty_album) { create(:photo_album) }
    let!(:untagged_album) { create(:photo_album) }
    let!(:partially_tagged_album) { create(:photo_album) }
    let!(:mostly_tagged_album) { create(:photo_album) }
    let!(:fully_tagged_album) { create(:photo_album) }
    let!(:deleted_tag_album) { create(:photo_album) }

    before do
      create_list(:photo, 2, photo_album: untagged_album)

      create(:photo_tag, photo: create(:photo, photo_album: partially_tagged_album))
      create(:photo, photo_album: partially_tagged_album)

      create(:photo, photo_album: mostly_tagged_album)
      create_list(:photo, 9, photo_album: mostly_tagged_album).each { |photo| create(:photo_tag, photo:) }

      photo = create(:photo, photo_album: fully_tagged_album)
      create_list(:photo_tag, 2, photo:)

      create(:photo_tag, photo: create(:photo, photo_album: deleted_tag_album)).destroy
    end

    it { expect(albums).not_to include(empty_album) }
    it { expect(albums).to include(untagged_album) }
    it { expect(albums).to include(partially_tagged_album) }
    it { expect(albums).not_to include(mostly_tagged_album) }
    it { expect(albums).not_to include(fully_tagged_album) }
    it { expect(albums).to include(deleted_tag_album) }
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
