require 'rails_helper'

RSpec.describe MailReceiveJob, type: :job do
  describe '#perform' do
    let(:mail_fetcher_class) { class_double(MailgunFetcher::Mail).as_stubbed_const }
    let(:job) { described_class.new }
    let(:message_url) { 'https://example.org' }

    before do
      ActionMailer::Base.deliveries = []
    end

    context 'when recipient mail alias does not exist' do
      let(:sender) { 'alice@example.org' }
      let(:ndr_mail) { ActionMailer::Base.deliveries.first }

      before do
        ActionMailer::Base.deliveries = []
        allow(mail_fetcher_class).to receive(:new) { OpenStruct.new(sender: sender) }
        perform_enqueued_jobs do
          described_class.perform_now('unknown@csvalpha.nl', message_url)
        end
      end

      it { expect(ndr_mail).not_to be nil }
      it { expect(ndr_mail.to.first).to eq 'alice@example.org' }

      context 'when sender is noreply' do
        let(:sender) { 'noreply@csvalpha.nl' }

        it { expect(ndr_mail).to be nil }
      end
    end

    context 'when recipient mail alias exists' do
      let(:mail_alias) { FactoryBot.create(:mail_alias, :with_user) }

      before do
        allow(mail_fetcher_class).to receive(:new).with(an_instance_of(String))
        job.perform(mail_alias.email, message_url)
        mail_alias.reload
      end

      it { expect(mail_fetcher_class).to have_received(:new).with(message_url) }
      it { expect(MailForwardJob).to have_been_enqueued.with(mail_alias, message_url) }
      it { expect(mail_alias.last_received_at).to be_within(10.seconds).of Time.zone.now }
    end

    context 'when recipient mail alias is contains uppercase' do
      let(:mail_alias) { FactoryBot.create(:mail_alias, :with_user, email: 'test@csvalpha.nl') }

      before do
        mail_alias
        allow(mail_fetcher_class).to receive(:new).with(an_instance_of(String))
        job.perform('Test@csvalpha.nl', message_url)
      end

      it { expect(mail_fetcher_class).to have_received(:new).with(message_url) }
    end
  end
end
