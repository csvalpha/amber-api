require 'rails_helper'

describe V1::MailAliasesController do
  describe 'POST /mail_aliases', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { build(:mail_alias, group: create(:group), user: nil) }
      let(:record_url) { '/v1/mail_aliases' }
      let(:record_permission) { 'mail_alias.create' }
      let(:valid_relationships) { { group: { data: { id: record.group_id, type: 'groups' } } } }
      let(:invalid_attributes) { { email: '' } }
    end
  end
end
