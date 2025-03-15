require 'rails_helper'

RSpec.describe Photo do
  subject(:photo) { build_stubbed(:photo) }

  describe '#valid?' do
    it { expect(photo).to be_valid }

    context 'when without an image' do
      subject(:photo) { build_stubbed(:photo, image: nil) }

      it { expect(photo).not_to be_valid }
    end

    context 'when without an original filename' do
      subject(:photo) { build_stubbed(:photo, original_filename: nil) }

      it { expect(photo).not_to be_valid }
    end

    context 'when without an photo album' do
      subject(:photo) { build_stubbed(:photo, photo_album: nil) }

      it { expect(photo).not_to be_valid }
    end

    context 'when without an uploader' do
      subject(:photo) { build_stubbed(:photo, uploader: nil) }

      it { expect(photo).not_to be_valid }
    end
  end

  describe '#with_comments' do
    let(:photo_with_comments) { create(:photo) }
    let(:photo_with_one_comment) { create(:photo) }

    before do
      create(:photo_comment, photo: photo_with_comments)
      create(:photo_comment, photo: photo_with_comments)
      create(:photo_comment, photo: photo_with_one_comment)
      create(:photo)
    end

    it { expect(described_class.count).to be 3 }
    it { expect(described_class.with_comments.count).to be 2 }
  end

  describe '#with_tags' do
    let(:photo_with_tags) { create(:photo) }
    let(:photo_with_one_tag) { create(:photo) }

    before do
      create(:photo_tag, photo: photo_with_tags)
      create(:photo_tag, photo: photo_with_tags)
      create(:photo_tag, photo: photo_with_one_tag)
      create(:photo)
    end

    it { expect(described_class.count).to be 3 }
    it { expect(described_class.with_tags.count).to be 2 }
  end

  describe '#visibilty' do
    let(:alumni_album) { create(:photo_album, visibility: 'alumni') }
    let(:private_album) { create(:photo_album, visibility: 'members') }

    before do
      create(:photo, photo_album: alumni_album)
      create(:photo, photo_album: alumni_album)
      create(:photo, photo_album: private_album)
    end

    it { expect(described_class.where(visibility: %w[alumni public]).count).to be 2 }
    it { expect(described_class.count - described_class.where(visibility: %w[alumni public]).count).to be 1 }
  end

  describe '#extract_exif' do
    subject(:photo) { create(:photo) }

    it { expect(photo.exif_make).to eq 'Nikon' }
    it { expect(photo.exif_model).to eq 'Nikon D500' }
    it { expect(photo.exif_exposure_time).to eq '1/100' }
    it { expect(photo.exif_aperture_value).to eq '3.5' }
    it { expect(photo.exif_iso_speed_ratings).to eq '400' }
    it { expect(photo.exif_copyright).to eq 'C.S.V. Alpha' }
    it { expect(photo.exif_lens_model).to eq 'Nikkor AF-S 24-70mm f/2.8G ED' }
    it { expect(photo.exif_focal_length).to eq 50 }
  end

  describe '#extract_exif_on_png' do
    subject(:photo) { create(:photo, :png) }

    it { expect(photo.exif_make).to be_nil }
  end
end
