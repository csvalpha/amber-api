require 'rails_helper'

describe V1::MailAliasesController do
  describe 'PUT /mail_aliases/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:mail_alias, :with_group) }
      let(:record_url) { "/v1/mail_aliases/#{record.id}" }
      let(:record_permission) { 'mail_alias.update' }
      let(:invalid_attributes) { { email: '' } }
    end
  end
end
