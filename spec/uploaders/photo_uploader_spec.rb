require 'rails_helper'
require 'carrierwave/test/matchers'

describe PhotoUploader do
  include CarrierWave::Test::Matchers

  let(:path_to_file) { Rails.root.join('spec', 'support', 'files', 'pixel.jpg') }
  let(:photo) { FactoryBot.create(:photo) }

  subject(:photo_uploader) { described_class.new(photo) }

  before do
    described_class.enable_processing = true
    File.open(path_to_file) { |f| photo_uploader.store!(f) }
  end

  after do
    described_class.enable_processing = false
  end

  describe '#store_dir' do
    it do
      expect(photo_uploader.store_dir).to(
        end_with "uploads/photo_albums/#{photo.photo_album.id}/photos/#{photo.id}"
      )
    end
  end

  describe 'when processed' do
    it { expect(photo_uploader).to be_no_larger_than(2048, 2048) }
    it { expect(photo_uploader.thumb).to have_dimensions(256, 256) }
    it { expect(photo_uploader.medium).to be_no_larger_than(512, 384) }
  end
end
