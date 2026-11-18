require 'rails_helper'

RSpec.describe NextcloudWebdav do
  subject(:client) { described_class.new(url: 'https://cloud.example.com/', user: 'questor', password: 'secret') }

  let(:base_url) { 'https://cloud.example.com/remote.php/dav/files/questor' }

  describe '#upload' do
    let!(:mkcol_root) { stub_request(:mkcol, "#{base_url}/Declaraties").to_return(status: 405) }
    let!(:mkcol_year) { stub_request(:mkcol, "#{base_url}/Declaraties/2026").to_return(status: 201) }
    let!(:put) do
      stub_request(:put, "#{base_url}/Declaraties/2026/bon%20%231.pdf")
        .with(body: 'pdf', basic_auth: %w[questor secret]).to_return(status: 201)
    end

    before { client.upload('Declaraties/2026/bon #1.pdf', 'pdf') }

    it { expect(mkcol_root).to have_been_requested }
    it { expect(mkcol_year).to have_been_requested }
    it { expect(put).to have_been_requested }

    context 'when the upload fails' do
      before { stub_request(:put, "#{base_url}/Declaraties/2026/bon.pdf").to_return(status: 507) }

      it { expect { client.upload('Declaraties/2026/bon.pdf', 'pdf') }.to raise_error(NextcloudWebdav::Error) }
    end
  end

  describe '#delete' do
    it 'ignores files that are already gone' do
      stub_request(:delete, "#{base_url}/old.pdf").to_return(status: 404)
      expect { client.delete('old.pdf') }.not_to raise_error
    end
  end

  describe '.configured?' do
    it { expect(described_class.configured?).to be false }

    context 'when configured' do
      before do
        allow(Rails.application.config.x).to receive_messages(nextcloud_url: 'https://cloud.example.com',
                                                              nextcloud_declarations_user: 'questor',
                                                              nextcloud_declarations_password: 'secret')
      end

      it { expect(described_class.configured?).to be true }
      it { expect(described_class.from_config).to be_a described_class }
    end
  end
end
