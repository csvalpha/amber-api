require 'rails_helper'

describe V1::PermissionsController do
  describe 'GET /permissions/:id', version: 1 do
    let(:record) { create(:permission) }
    let(:record_url) { "/v1/permissions/#{record.id}" }
    let(:record_permission) { 'permission.read' }
    let(:valid_request) { get(record_url) }

    it_behaves_like 'a permissible model'
  end
end
