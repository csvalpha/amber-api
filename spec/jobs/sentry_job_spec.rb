require 'rails_helper'

RSpec.describe SentryJob do
  describe '#perform' do
    let(:job) { described_class.new }

    before do
      allow(Raven).to receive(:send_event)
      job.perform('Example event')
    end

    it { expect(Raven).to have_received(:send_event).with('Example event') }
  end
end
