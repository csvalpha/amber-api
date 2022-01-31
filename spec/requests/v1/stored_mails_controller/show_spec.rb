require 'rails_helper'

describe V1::StoredMailsController do
  describe 'GET /stored_mails/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:stored_mail) }
      let(:record_url) { "/v1/stored_mails/#{record.id}" }
      let(:record_permission) { 'stored_mail.read' }
    end
  end
end
