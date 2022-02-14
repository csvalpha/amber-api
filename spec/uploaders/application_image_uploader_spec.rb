require 'rails_helper'
require 'carrierwave/test/matchers'

describe ApplicationImageUploader do
  include CarrierWave::Test::Matchers

  let(:path_to_jpg_file) { Rails.root.join('spec', 'support', 'files', 'pixel.jpg') }
  let(:path_to_gif_file) { Rails.root.join('spec', 'support', 'files', 'pixel.gif') }
  let(:gif_as_jpg_file) { Rails.root.join('spec', 'support', 'files', 'gif_disguised.jpg') }
  let(:jpg_as_gif_file) { Rails.root.join('spec', 'support', 'files', 'jpg_disguised.gif') }

  let(:user) { build_stubbed(:user) }

  subject(:application_image_uploader) { described_class.new(user) }

  it do
    expect { File.open(path_to_jpg_file) { |f| application_image_uploader.store!(f) } }.not_to(
      raise_error
    )
  end

  it do
    expect { File.open(path_to_gif_file) { |f| application_image_uploader.store!(f) } }.to(
      raise_error(CarrierWave::IntegrityError)
    )
  end

  it do
    expect { File.open(gif_as_jpg_file) { |f| application_image_uploader.store!(f) } }.to(
      raise_error(CarrierWave::IntegrityError)
    )
  end

  it do
    expect { File.open(jpg_as_gif_file) { |f| application_image_uploader.store!(f) } }.to(
      raise_error(CarrierWave::IntegrityError)
    )
  end
end
