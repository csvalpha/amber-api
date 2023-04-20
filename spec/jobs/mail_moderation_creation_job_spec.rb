require 'rails_helper'

RSpec.describe MailModerationCreationJob, type: :job do
  let(:raw_url) { 'https://example.com/raw_email' }
  let(:response_body) { 'raw_email_data' }
  let(:response) do
    instance_double(Net::HTTPResponse, code: '200', message: 'OK', body: response_body)
  end

  describe '#perform' do
    it 'creates and extracts message ID from inbound email' do # rubocop:disable RSpec/ExampleLength
      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(Net::HTTP).to receive(:start).and_return(response)

      allow(ActionMailbox::InboundEmail).to receive(:create_and_extract_message_id!)

      described_class.perform_now(raw_url)

      expect(ActionMailbox::InboundEmail).to have_received(:create_and_extract_message_id!)
        .with(response_body)
    end

    it 'raises an error when the client does not return a 200 HTTP response' do
      response = instance_double(Net::HTTPResponse, code: '404', message: 'Not Found',
                                                    body: 'raw_email_not_found')
      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      allow(Net::HTTP).to receive(:start).and_return(response)
      expect { described_class.perform_now(raw_url) }.to raise_error(RuntimeError)
    end
  end
end
