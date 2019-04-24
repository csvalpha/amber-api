require 'rails_helper'

describe V1::MembershipsController do
  describe 'GET /memberships/:id', version: 1 do
    let(:record) { FactoryBot.create(:membership) }
    let(:record_url) { "/v1/memberships/#{record.id}" }
    let(:record_permission) { 'membership.read' }

    it_behaves_like 'a permissible model'
  end
end
