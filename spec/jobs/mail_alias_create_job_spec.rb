require 'rails_helper'

RSpec.describe MailAliasCreateJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    let(:improvmx_class) { class_double(Improvmx::Client) }
    let(:improvmx) { instance_double(Improvmx::Client) }

    before do
      stub_const('Improvmx::Client', improvmx_class)
      allow(improvmx_class).to receive(:new).and_return(improvmx)
      allow(improvmx).to receive(:create_or_update_alias).and_return(200)
      job.perform('test', ['user@example.com', 'second@example.com'], 'test.csvalpha.nl')
    end

    context 'it creates the alias' do
      it {
        expect(improvmx).to have_received(:create_or_update_alias)
          .with('test', ['user@example.com', 'second@example.com'],
                'test.csvalpha.nl')
      }
    end
  end
end
