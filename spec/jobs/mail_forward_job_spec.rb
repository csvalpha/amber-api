require 'rails_helper'
require Rails.root.join('spec', 'support', 'mocks', 'fake_http')

RSpec.describe MailForwardJob, type: :job do
  describe '#perform' do
    let(:job) { described_class.new }
    let(:mail_alias) { FactoryBot.create(:mail_alias, :with_user) }
    let(:message_url) { 'https://example.org' }
    let(:http) { class_double('HTTP') }
    let(:fake_http) { instance_double(FakeHTTP) }

    before do
      stub_const('HTTP', http)
      allow(http).to receive(:basic_auth).and_return(fake_http)
      allow(fake_http).to receive(:post)
      job.perform(mail_alias, message_url)
    end

    context 'when with open alias' do
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_user, email: 'testing@sandbox86621.eu.mailgun.org')
      end

      it do
        expect(fake_http).to have_received(:post).with(
          message_url, form: { to: 'testing@alpha.sandbox86621.eu.mailgun.org' }
        )
      end
    end

    context 'when with (semi)moderated alias' do
      let(:mail_alias) { FactoryBot.create(:mail_alias, :with_user, :with_moderator) }

      it do
        expect(fake_http).to have_received(:post).with(
          message_url, form: { to: mail_alias.user.email }
        )
      end
    end
  end
end
