require 'rails_helper'

RSpec.describe MailAliasDestroyJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    let(:improvmx_class) { class_double(Improvmx::Client) }
    let(:improvmx) { instance_double(Improvmx::Client) }

    before do
      stub_const('Improvmx::Client', improvmx_class)
      allow(improvmx_class).to receive(:new).and_return(improvmx)
      allow(improvmx).to receive(:delete_alias).and_return(200)
      job.perform('test', 'test.csvalpha.nl')
    end

    context 'it removes the alias' do
      it {
        expect(improvmx).to have_received(:delete_alias)
                              .with('test', 'test.csvalpha.nl')
      }
    end
  end
end
