require 'rails_helper'

describe V1::MailAliasesController do
  describe 'GET /mail_aliases/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { FactoryBot.create(:mail_alias, :with_group) }
      let(:record_url) { "/v1/mail_aliases/#{record.id}" }
      let(:record_permission) { 'mail_alias.read' }
    end
  end
end
