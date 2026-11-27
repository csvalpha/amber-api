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

    context 'when without visibility' do
      subject(:photo_album) { build_stubbed(:photo_album, visibility: nil) }

      it { expect(photo_album).not_to be_valid }
    end

    context 'when with an unknown visibility' do
      subject(:photo_album) { build_stubbed(:photo_album, visibility: 'everyone') }

      it { expect(photo_album).not_to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#publicly_visible' do
    before do
      create(:photo_album, :public)
      create(:photo_album, :alumni)
      create(:photo_album)
    end

    it { expect(described_class.publicly_visible.count).to be 1 }
    it { expect(described_class.publicly_visible.first.visibility).to eq 'public' }
  end

  describe '#visible_in_period' do
    subject(:albums) { described_class.visible_in_period(3.years.ago.to_date, 1.year.ago.to_date) }

    let!(:public_album) { create(:photo_album, :public, date: 10.years.ago) }
    let!(:alumni_album) { create(:photo_album, :alumni, date: 10.years.ago) }
    let!(:album_in_period) { create(:photo_album, date: 2.years.ago) }
    let!(:album_before_period) { create(:photo_album, date: 4.years.ago) }
    let!(:album_after_period) { create(:photo_album, date: 1.month.ago) }
    let!(:undated_album_in_period) { create(:photo_album, date: nil, created_at: 2.years.ago) }
    let!(:undated_album_after_period) { create(:photo_album, date: nil) }

    it { expect(albums).to include(public_album, alumni_album) }
    it { expect(albums).to include(album_in_period, undated_album_in_period) }
    it { expect(albums).not_to include(album_before_period, album_after_period, undated_album_after_period) }
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
