require 'rails_helper'

RSpec.describe PdfRasterizer do
  let(:files) { Rails.root.join('spec', 'support', 'files') }
  let(:pdf_path) { files.join('receipt.pdf').to_s }

  describe '.first_page' do
    it 'renders a jpg bounded to A4 at 150 dpi' do
      image = MiniMagick::Image.open(described_class.first_page(pdf_path).path)
      expect([image.type, image.width <= 1241, image.height <= 1755]).to eq ['JPEG', true, true]
    end

    it 'raises when ghostscript exceeds the deadline' do
      stub_const('PdfRasterizer::TIMEOUT', 0)
      expect { described_class.first_page(pdf_path) }.to raise_error(PdfRasterizer::Error)
    end

    it 'raises when the file can not be rendered' do
      expect { described_class.first_page(files.join('user_import.csv').to_s) }.to raise_error(PdfRasterizer::Error)
    end
  end
end
