require 'rails_helper'

RSpec.describe ReceiptUploader do
  let(:declaration) { create(:declaration) }
  let(:uploader) { described_class.new(declaration, :receipt) }

  def upload(name, content_type)
    Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'files', name), content_type)
  end

  it { expect(uploader.root).to eq Rails.root.join('private_uploads').to_s }
  it { expect(uploader.root).not_to start_with Rails.public_path.to_s }

  context 'when processing images' do
    before { described_class.enable_processing = true }
    after { described_class.enable_processing = false }

    it 'converts a png to jpg' do
      uploader.store!(upload('pixel.png', 'image/png'))
      expect([uploader.file.extension, uploader.file.content_type]).to eq %w[jpg image/jpeg]
    end

    it 'keeps a pdf as pdf' do
      uploader.store!(upload('receipt.pdf', 'application/pdf'))
      expect(uploader).to be_pdf
    end
  end

  it 'rejects other file types' do
    expect { uploader.store!(upload('collection_import.csv', 'text/csv')) }.to raise_error(CarrierWave::IntegrityError)
  end

  context 'when a file is declared as pdf but is not a pdf' do
    let(:fake_pdf) do
      Tempfile.new(%w[fake .pdf]).tap do |file|
        file.write("username,amount\nfoo,1\n")
        file.flush
      end
    end

    after { fake_pdf.close! }

    it do
      expect { uploader.store!(Rack::Test::UploadedFile.new(fake_pdf.path, 'application/pdf')) }
        .to raise_error(CarrierWave::IntegrityError)
    end
  end

  it { expect(uploader.size_range).to eq(1..(10.megabytes)) }
end
