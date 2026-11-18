require 'rails_helper'

RSpec.describe DeclarationPdf do
  subject(:pdf) { described_class.new(declaration) }

  let(:user) { create(:user, first_name: 'Jan', last_name_prefix: 'de', last_name: 'Vries') }
  let(:declaration) do
    create(:declaration, :approved, user:, amount: 12.5, description: 'Boodschappen borrel',
                                    purchase_date: Date.new(2026, 11, 1))
  end
  let(:text) { PDF::Inspector::Text.analyze(pdf.render).strings.join(' ') }

  describe '#filename' do
    it do
      expect(pdf.filename).to eq "2026-11-01_vries-de-jan_boodschappen-borrel_EUR12.50_id#{declaration.id}.pdf"
    end
  end

  describe '#folder' do
    it { expect(pdf.folder).to eq '2026' }
  end

  describe '#render' do
    it { expect(pdf.render).to start_with '%PDF' }
    it { expect(PDF::Inspector::Page.analyze(pdf.render).pages.size).to eq 1 }
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
      it { expect(PDF::Inspector::Page.analyze(pdf.render).pages.size).to eq 1 }
    end

    context 'when with a pdf receipt' do
      let(:declaration) { create(:declaration, :approved, :with_pdf_receipt) }

      it { expect(PDF::Inspector::Page.analyze(pdf.render).pages.size).to eq 1 }
    end

    context 'when the description contains characters outside of the font' do
      let(:declaration) { create(:declaration, :approved, description: 'Taart 🎂') }

      it { expect(text).to include 'Taart ?' }
    end
  end
end
