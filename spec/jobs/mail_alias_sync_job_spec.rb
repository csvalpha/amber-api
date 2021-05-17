require 'rails_helper'
require Rails.root.join('spec', 'support', 'mocks', 'fake_http')

RSpec.describe MailAliasSyncJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    let(:mail_alias) do
      FactoryBot.create(:mail_alias, :with_user, email: 'test@sandbox86621.eu.mailgun.org')
    end
    let(:improvmx_class) { class_double(Improvmx::Client) }
    let(:improvmx) { instance_double(Improvmx::Client) }

    before do
      stub_const('Improvmx::Client', improvmx_class)
      allow(improvmx_class).to receive(:new).and_return(improvmx)
      allow(improvmx).to receive(:create_or_update_alias).and_return(200)
      allow(improvmx).to receive(:delete_alias).and_return(200)
      job.perform(mail_alias.id)
    end

    context 'when it is a existing alias' do
      it {
        expect(improvmx).to have_received(:create_or_update_alias)
          .with('test', [mail_alias.user.email],
                'alpha.sandbox86621.eu.mailgun.org')
      }
    end

    context 'when it is an empty existing alias' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_group, email: 'test@sandbox86621.eu.mailgun.org')
      end

      it {
        expect(improvmx).to have_received(:delete_alias).with('test',
                                                              'alpha.sandbox86621.eu.mailgun.org')
      }
    end

    context 'when it is an destroyed alias' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, email: 'test@sandbox86621.eu.mailgun.org',
                                                   deleted_at: Time.zone.now)
      end

      it {
        expect(improvmx).to have_received(:delete_alias).with('test',
                                                              'alpha.sandbox86621.eu.mailgun.org')
      }
    end

    context 'when it is a moderated alias' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, :with_moderator,
                          email: 'test@sandbox86621.eu.mailgun.org')
      end
      let(:ingress_password) do
        Rails.application.credentials.action_mailbox.fetch(:ingress_password)
      end
      let(:forward_url) do
        "http://actionmailbox:#{ingress_password}" \
          '@testhost:1337/api/rails/action_mailbox/improvmx/inbound_emails'
      end

      it do
        expect(improvmx).to have_received(:create_or_update_alias)
          .with('test', forward_url,
                'alpha.sandbox86621.eu.mailgun.org')
      end
    end

    context 'when it is rate limited' do
      context 'when it recovers' do
        before do
          allow(improvmx).to receive(:create_or_update_alias)
            .once.and_raise(Improvmx::RateLimitError)
          allow(improvmx).to receive(:create_or_update_alias).once.and_return(200)
          job.perform(mail_alias.id)
        end

        it {
          expect(improvmx).to have_received(:create_or_update_alias)
            .twice
            .with('test', [mail_alias.user.email],
                  'alpha.sandbox86621.eu.mailgun.org')
        }
      end

      context 'when it keeps failing' do
        before do
          allow(improvmx).to receive(:create_or_update_alias).and_raise(Improvmx::RateLimitError)
        end

        it {
          expect { job.perform(mail_alias.id) }.to raise_error(Improvmx::RateLimitError)
        }
      end
    end
  end
end
