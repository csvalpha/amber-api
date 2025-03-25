require 'rails_helper'

describe V1::StoredMailsController do
  describe 'GET /stored_mails', version: 1 do
    let(:request) { get(record_url) }
    let(:record_url) { '/v1/stored_mails' }
    let(:records) { create_list(:stored_mail, 3) }
    let(:record_permission) { 'stored_mail.read' }

    it_behaves_like 'an indexable model'

    describe 'when user is moderator' do
      include_context 'when authenticated' do
        let(:user) { create(:user) }
      end
      let(:moderator_group) { create(:group, users: [user]) }
      let(:mail_alias) do
        create(:mail_alias, :with_group, :with_moderator,
               moderator_group:)
      end

      before do
        create(:stored_mail)
        create_list(:stored_mail, 2, mail_alias:)
        Bullet.enable = false
      end

      after { Bullet.enable = true }

      it_behaves_like '200 OK'
      it { expect(json['data'].count).to eq 2 }
    end
  end
end
