require 'rails_helper'

describe V1::StoredMailsController do
  describe 'POST /stored_mails/:id/reject', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:request) { perform_enqueued_jobs { post(record_url) } }
      let(:record) { create(:stored_mail) }
      let(:record_url) { "/v1/stored_mails/#{record.id}/reject" }
      let(:record_permission) { 'stored_mail.destroy' }
    end
  end
end
