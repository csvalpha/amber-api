require 'rails_helper'
require Rails.root.join('spec', 'support', 'mocks', 'fake_http')

RSpec.describe MailAliasSyncJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    let(:mail_alias) do
      FactoryBot.create(:mail_alias, :with_user, email: 'test@sandbox86621.eu.mailgun.org')
    end
    let(:http) { class_double('HTTP') }
    let(:fake_http) { instance_double(FakeHTTP) }
    let(:put_response_object) { instance_double('HTTP::Response') }
    let(:post_response_object) { instance_double('HTTP::Response') }
    let(:put_response) { 200 }
    let(:post_response) { 200 }

    before do
      stub_const('HTTP', http)
      allow(http).to receive(:basic_auth).and_return(fake_http)
      allow(put_response_object).to receive(:code).and_return(put_response)
      allow(fake_http).to receive(:put).and_return(put_response_object)
      allow(post_response_object).to receive(:code).and_return(post_response)
      allow(fake_http).to receive(:post).and_return(post_response_object)
      job.perform(mail_alias.id)
    end

    context 'when it is a new alias' do
      let(:put_response) { 404 }

      it { expect(fake_http).to have_received(:put) }

      it do
        expect(fake_http).to have_received(:post).with(
          'https://api.improvmx.com/v3/domains/alpha.sandbox86621.eu.mailgun.org/aliases/',
          form: { alias: 'test', forward: mail_alias.user.email }
        )
      end
    end

    context 'when it is an existing alias' do
      it do
        expect(fake_http).to have_received(:put).with(
          'https://api.improvmx.com/v3/domains/alpha.sandbox86621.eu.mailgun.org/aliases/test',
          form: { forward: mail_alias.user.email }
        )
      end

      it { expect(fake_http).not_to have_received(:post) }
    end

    context 'when it is a moderated alias' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, :with_moderator,
                          email: 'test@sandbox86621.eu.mailgun.org')
      end
      let(:ingress_password) do
        Rails.application.credentials.action_mailbox.fetch(:ingress_password)
      end

      it do
        expect(fake_http).to have_received(:put).with(
          'https://api.improvmx.com/v3/domains/alpha.sandbox86621.eu.mailgun.org/aliases/test',
          form: { forward: "http://api:#{ingress_password}
                            @testhost:1337/api/rails/action_mailbox/improvmx/inbound_emails" }
        )
      end
    end
  end
end
