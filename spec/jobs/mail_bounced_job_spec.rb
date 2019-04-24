require 'rails_helper'

RSpec.describe MailBouncedJob, type: :job do
  describe '#perform' do
    let(:mail_delivery) { ActionMailer::Base.deliveries.first }

    context 'complained' do
      let(:mail) do
        { event: 'complained', message: { headers: { to: 'Alice <alice@example.com>' } } }
      end
      let(:job) { described_class.new }

      before do
        allow(job).to receive(:send_slack_message)
        job.perform(mail)
      end

      it do
        expect(job).to have_received(:send_slack_message)
      end
    end

    context 'permanent' do
      context 'when sent by someone' do
        let(:mail) do
          { :event => 'failed', 'log-level' => 'error',
            :message => { headers: { to: 'Alice <alice@example.com>', from: 'bob@example.com' } } }
        end

        before do
          ActionMailer::Base.deliveries = []
          perform_enqueued_jobs do
            described_class.perform_now(mail)
          end
        end

        it { expect(mail_delivery).not_to be nil }
      end

      context 'when bounce is send by no-reply address' do
        let(:mail) do
          { :event => 'failed', 'log-level' => 'error',
            :message => { headers:
                            { to: 'Alice <alice@example.com>', from: 'no-reply@example.com' } } }
        end

        before do
          ActionMailer::Base.deliveries = []
          perform_enqueued_jobs do
            described_class.perform_now(mail)
          end
        end

        it { expect(mail_delivery).to be nil }
      end
    end
  end
end
