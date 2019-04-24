require 'rails_helper'
require Rails.root.join('spec', 'support', 'mocks', 'fake_mail')

describe V1::StoredMailsController do
  describe 'GET /stored_mails', version: 1 do
    before { stub_const('MailgunFetcher::Mail', FakeMail) }

    let(:request) { get(record_url) }
    let(:record_url) { '/v1/stored_mails' }
    let(:records) { FactoryBot.create_list(:stored_mail, 3) }
    let(:record_permission) { 'stored_mail.read' }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[sender subject]

    describe 'when user is moderator' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user) }
      end
      let(:moderator_group) { FactoryBot.create(:group, users: [user]) }
      let(:mail_alias) do
        FactoryBot.create(:mail_alias, :with_group, :with_moderator,
                          moderator_group: moderator_group)
      end

      before do
        FactoryBot.create(:stored_mail)
        FactoryBot.create_list(:stored_mail, 2, mail_alias: mail_alias)
      end

      it_behaves_like '200 OK'
      it { expect(json['data'].count).to eq 2 }
    end
  end
end
