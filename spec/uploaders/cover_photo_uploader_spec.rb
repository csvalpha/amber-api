require 'rails_helper'
require 'carrierwave/test/matchers'

describe CoverPhotoUploader do
  include CarrierWave::Test::Matchers

  let(:path_to_file) { Rails.root.join('spec', 'support', 'files', 'pixel.jpg') }
  let(:group) { FactoryBot.build_stubbed(:group) }

  subject(:group_cover_photo_uploader) { described_class.new(group) }

  before do
    described_class.enable_processing = true
    File.open(path_to_file) { |f| group_cover_photo_uploader.store!(f) }
  end

  after do
    described_class.enable_processing = false
  end

  describe '#store_dir' do
    it { expect(group_cover_photo_uploader.store_dir).to end_with "uploads/groups/#{group.id}/" }
  end

  describe 'when processed' do
    it { expect(group_cover_photo_uploader).to have_dimensions(640, 360) }
  end
end
