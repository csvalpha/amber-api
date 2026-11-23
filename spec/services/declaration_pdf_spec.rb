require 'rails_helper'

RSpec.describe DeclarationPdf do
  subject(:pdf) { described_class.new(declaration) }

  let(:user) { create(:user, first_name: 'Jan', last_name_prefix: 'de', last_name: 'Vries') }
  let(:declaration) do
    create(:declaration, :approved, user:, amount: 12.5, description: 'Boodschappen borrel',
                                    purchase_date: Date.new(2026, 11, 1), created_at: Time.zone.local(2026, 11, 18, 12))
  end
  let(:text) { PDF::Inspector::Text.analyze(pdf.render).strings.join(' ') }
  let(:page_count) { PDF::Inspector::Page.analyze(pdf.render).pages.size }

  describe '#filename' do
    it { expect(pdf.filename).to eq "2026-11-18_jan_de-vries_#{declaration.id}_declaratie.pdf" }

    context 'when the user has no last name prefix' do
      let(:user) { create(:user, first_name: 'Anne Marie', last_name_prefix: nil, last_name: "D'Artagnan") }

      it { expect(pdf.filename).to eq "2026-11-18_anne-marie_d-artagnan_#{declaration.id}_declaratie.pdf" }
    end
  end

  describe '#folder' do
    it { expect(pdf.folder).to eq '2026' }
  end

  describe '#render' do
    it { expect(pdf.render).to start_with '%PDF' }
    it { expect(page_count).to eq 1 }
    it { expect(text).to include 'Jan de Vries', '€ 12,50', 'Boodschappen borrel', '01-11-2026' }
    it { expect(text).to include 'Bon ontbreekt', declaration.missing_receipt_reason }
    it { expect(text).to include 'geen actief mandaat' }

    context 'when the user has a mandate' do
      let!(:mandate) { create(:mandate, user:) }

      it { expect(text).to include mandate.iban }
    end

    context 'when with an image receipt' do
      let(:declaration) { create(:declaration, :approved, :with_receipt) }

      it { expect(text).not_to include 'Bon ontbreekt' }
      it { expect(page_count).to eq 1 }
      it { expect(PDF::Inspector::XObject.analyze(pdf.render).page_xobjects.first).not_to be_empty }
    end

    context 'when with a pdf receipt' do
      let(:declaration) { create(:declaration, :approved, :with_pdf_receipt) }

      it { expect(page_count).to eq 1 }
      it { expect(PDF::Inspector::XObject.analyze(pdf.render).page_xobjects.first).not_to be_empty }
    end

    context 'when the reason for the missing receipt has the maximum length' do
      let(:reason) { "#{Array.new(42) { |i| "Regel #{i} van de uitleg" }.join("\n")}\nEINDE".first(1000) }
      let(:declaration) { create(:declaration, :approved, missing_receipt_reason: reason) }

      it { expect(reason.length).to be <= 1000 }
      it { expect(page_count).to eq 1 }
      it { expect(text).to include 'EINDE' }
    end

    context 'when the pdf receipt can not be rasterized' do
      let(:declaration) { create(:declaration, :approved, :with_pdf_receipt) }

      before { allow(PdfRasterizer).to receive(:first_page).and_raise(PdfRasterizer::Error) }

      it { expect(text).to include 'Bon kon niet worden weergegeven' }
      it { expect(page_count).to eq 1 }
    end

    context 'when the description contains many line breaks' do
      let(:declaration) { create(:declaration, :approved, description: "a\n" * 120) }

      it { expect(text).to include 'Goedgekeurd op' }
      it { expect(page_count).to eq 1 }
    end

    context 'when the description contains characters outside of the font' do
      let(:declaration) { create(:declaration, :approved, description: 'Taart 🎂') }

      it { expect(text).to include 'Taart ?' }
    end
  end
end
