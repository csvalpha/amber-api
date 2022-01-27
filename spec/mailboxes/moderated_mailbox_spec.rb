require 'rails_helper'

RSpec.describe ModeratedMailbox, type: :mailbox do
  subject(:receive_mail) do
    receive_inbound_email_from_mail(
      from: 'someone@example.com',
      to: mail_alias.email,
      subject: 'Sample Subject',
      body: "I'm a sample body"
    )
  end

  describe 'Moderated mail is converted into stored mail' do
    context 'When for moderated address' do
      let(:moderator) { FactoryBot.create(:user, email: 'moderator@test.csvalpha.nl') }
      let(:moderator_group) { FactoryBot.create(:group, users: [moderator]) }
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, moderation_type: :moderated,
                                                   moderator_group: moderator_group)
      end
      let(:awaiting_moderation_email) { ActionMailer::Base.deliveries.last }
      let(:request_for_moderation_email) { ActionMailer::Base.deliveries.first }

      before do
        ActionMailer::Base.deliveries = []

        perform_enqueued_jobs(except: MailModerationReminderJob) do
          receive_mail
        end
      end

      it { expect(StoredMail.first.mail_alias).to eq mail_alias }
      it { expect(StoredMail.first.inbound_email).to eq receive_mail }

      it { expect(awaiting_moderation_email.to.first).to include('someone@example.com') }

      it do
        expect(awaiting_moderation_email.subject).to include('Moderatieverzoek in behandeling:')
      end

      it { expect(request_for_moderation_email.to.first).to include('moderator@test.csvalpha.nl') }
      it { expect(request_for_moderation_email.subject).to include('Moderatieverzoek:') }

      it { expect(enqueued_jobs.first['job_class']).to eq 'MailModerationReminderJob' }
    end

    context 'When for non-moderated address' do
      let(:mail_alias) { FactoryBot.create(:mail_alias) }

      it { expect { receive_mail }.not_to change(StoredMail, :count) }
    end

    context 'When for non-existing address' do
      let(:mail_alias) { FactoryBot.build(:mail_alias) }

      it { expect { receive_mail }.not_to change(StoredMail, :count) }
    end
  end
end
