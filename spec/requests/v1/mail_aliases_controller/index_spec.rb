require 'rails_helper'

describe V1::MailAliasesController do
  describe 'GET /mail_aliases', version: 1 do
    let(:records) { create_list(:mail_alias, 3, :with_group) }
    let(:record_url) { '/v1/mail_aliases' }
    let(:record_permission) { 'mail_alias.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[email description]
  end
end
