require 'rails_helper'

describe V1::StoredMailsController do
  describe 'DELETE /stored_mails/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:stored_mail) }
      let(:record_url) { "/v1/stored_mails/#{record.id}" }
      let(:record_permission) { 'stored_mail.destroy' }
    end
  end
end
