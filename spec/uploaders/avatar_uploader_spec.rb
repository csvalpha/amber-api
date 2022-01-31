require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:path_to_file) { Rails.root.join('spec', 'support', 'files', 'pixel.jpg') }
  let(:user) { build_stubbed(:user) }

  subject(:user_avatar_uploader) { described_class.new(user) }

  before do
    described_class.enable_processing = true
    File.open(path_to_file) { |f| user_avatar_uploader.store!(f) }
  end

  after do
    described_class.enable_processing = false
  end

  describe '#store_dir' do
    it { expect(user_avatar_uploader.store_dir).to end_with "uploads/users/#{user.id}/" }
  end

  describe 'when processed' do
    it { expect(user_avatar_uploader).to be_no_larger_than(2048, 2048) }
    it { expect(user_avatar_uploader.thumb).to have_dimensions(196, 196) }
  end
end
