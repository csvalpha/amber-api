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
      end

      it { expect(mail_fetcher_class).to have_received(:new).with(message_url) }
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

    context 'when recipient is an open mail alias' do
      let(:mail_alias) { FactoryBot.create(:mail_alias, :with_user, moderation_type: :open) }

      before do
        job.perform(mail_alias.email, message_url)
        mail_alias.reload
      end

      it { expect(MailForwardJob).to have_been_enqueued.with(mail_alias, message_url) }
      it { expect(mail_alias.last_received_at).to be_within(10.seconds).of Time.zone.now }
    end

    context 'when recipient is a semi moderated mail alias and sender belongs to it' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, moderation_type: :semi_moderated,
                                                   moderator_group: FactoryBot.create(:group))
      end

      before do
        allow(mail_fetcher_class).to receive(:new) { OpenStruct.new(sender: mail_alias.user.email) }
        job.perform(mail_alias.email, message_url)
        mail_alias.reload
      end

      it { expect(MailForwardJob).to have_been_enqueued.with(mail_alias, message_url) }
      it { expect(MailModerationMailer).not_to have_been_enqueued }
      it { expect(mail_alias.last_received_at).to be_within(10.seconds).of Time.zone.now }
    end

    context 'when recipient is a semi moderated mail alias and sender is not recognized' do
      let(:moderator) { FactoryBot.create(:user, email: 'moderator@csvalpha.nl') }
      let(:moderator_group) { FactoryBot.create(:group, users: [moderator]) }
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, moderation_type: :moderated,
                                                   moderator_group: moderator_group)
      end
      let(:fetched_mail) { OpenStruct.new(sender: 'unknown@example.org', received_at: 1.hour.ago) }
      let(:awaiting_moderation_email) { ActionMailer::Base.deliveries.last }
      let(:request_for_moderation_email) { ActionMailer::Base.deliveries.first }

      before do
        allow(mail_fetcher_class).to receive(:new) { fetched_mail }

        perform_enqueued_jobs(except: MailModerationReminderJob) do
          job.perform(mail_alias.email, message_url)
        end
        mail_alias.reload
      end

      it { expect(awaiting_moderation_email.to.first).to include('unknown@example.org') }

      it do
        expect(awaiting_moderation_email.subject).to include('Moderatieverzoek in behandeling:')
      end

      it { expect(request_for_moderation_email.to.first).to include('moderator@csvalpha.nl') }
      it { expect(request_for_moderation_email.subject).to include('Moderatieverzoek:') }
      it { expect(MailForwardJob).not_to have_been_enqueued }
      it { expect(mail_alias.last_received_at).to be_within(10.seconds).of Time.zone.now }
      it { expect { job.perform(mail_alias.email, message_url) }.to have_enqueued_job(MailModerationReminderJob) }
    end

    context 'when recipient is a moderated mail alias and sender is recognized' do
      let(:moderator) { FactoryBot.create(:user, email: 'moderator@csvalpha.nl') }
      let(:moderator_group) { FactoryBot.create(:group, users: [moderator]) }
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, moderation_type: :moderated,
                                                   moderator_group: moderator_group)
      end
      let(:fetched_mail) { OpenStruct.new(sender: mail_alias.user.email, received_at: 1.hour.ago) }
      let(:awaiting_moderation_email) { ActionMailer::Base.deliveries.last }
      let(:request_for_moderation_email) { ActionMailer::Base.deliveries.first }

      before do
        ActionMailer::Base.deliveries = []
        allow(mail_fetcher_class).to receive(:new) { fetched_mail }

        perform_enqueued_jobs(except: MailModerationReminderJob) do
          job.perform(mail_alias.email, message_url)
        end
        mail_alias.reload
      end

      it { expect(awaiting_moderation_email.to.first).to include(mail_alias.user.email) }

      it do
        expect(awaiting_moderation_email.subject).to include('Moderatieverzoek in behandeling:')
      end

      it { expect(request_for_moderation_email.to.first).to include('moderator@csvalpha.nl') }
      it { expect(request_for_moderation_email.subject).to include('Moderatieverzoek:') }
      it { expect(MailForwardJob).not_to have_been_enqueued }
      it { expect(mail_alias.last_received_at).to be_within(10.seconds).of Time.zone.now }
      it { expect { job.perform(mail_alias.email, message_url) }.to have_enqueued_job(MailModerationReminderJob) }
    end
  end
end
