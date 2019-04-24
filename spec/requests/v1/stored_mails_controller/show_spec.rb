require 'rails_helper'
require Rails.root.join('spec', 'support', 'mocks', 'fake_mail')

describe V1::StoredMailsController do
  describe 'GET /stored_mails/:id', version: 1 do
    before { stub_const('MailgunFetcher::Mail', FakeMail) }

    it_behaves_like 'a permissible model' do
      let(:record) { FactoryBot.create(:stored_mail) }
      let(:record_url) { "/v1/stored_mails/#{record.id}" }
      let(:record_permission) { 'stored_mail.read' }
    end
  end
end
