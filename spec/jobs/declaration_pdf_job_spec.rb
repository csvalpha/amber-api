require 'rails_helper'

RSpec.describe DeclarationPdfJob do
  let(:declaration) { create(:declaration, :approved, purchase_date: Date.new(2026, 11, 1)) }
  let(:filename) { DeclarationPdf.new(declaration).filename }
  let(:base_url) { 'https://cloud.example.com/remote.php/dav/files/questor' }
  let(:configured) { true }

  before do
    allow(Rails.application.config.x).to receive_messages(nextcloud_url: 'https://cloud.example.com',
                                                          nextcloud_declarations_user: 'questor',
                                                          nextcloud_declarations_password: 'secret')
    allow(NextcloudWebdav).to receive(:configured?).and_return(configured)
    stub_request(:mkcol, /#{base_url}/o).to_return(status: 201)
    stub_request(:put, /#{base_url}/o).to_return(status: 201)
    stub_request(:delete, /#{base_url}/o).to_return(status: 204)
  end

  describe '#perform' do
    before { described_class.perform_now(declaration) }

    it { expect(a_request(:put, "#{base_url}/Declaraties/2026/#{filename}")).to have_been_made }
    it { expect(declaration.reload.pdf_path).to eq "Declaraties/2026/#{filename}" }
    it { expect(declaration.reload.pdf_uploaded_at).to be_present }
    it { expect(a_request(:delete, /#{base_url}/o)).not_to have_been_made }

    context 'when a previous version with another name exists' do
      let(:declaration) { create(:declaration, :approved, pdf_path: 'Declaraties/2026/old.pdf') }

      it { expect(a_request(:delete, "#{base_url}/Declaraties/2026/old.pdf")).to have_been_made }
    end

    context 'when the declaration is not approved' do
      let(:declaration) { create(:declaration) }

      it { expect(a_request(:put, /#{base_url}/o)).not_to have_been_made }
    end

    context 'when Nextcloud is not configured' do
      let(:configured) { false }

      it { expect(a_request(:put, /#{base_url}/o)).not_to have_been_made }
      it { expect(declaration.reload.pdf_path).to be_nil }
    end
  end
end
