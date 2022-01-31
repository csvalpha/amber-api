require 'rails_helper'

describe V1::MembershipsController do
  describe 'DELETE /memberships/:id', version: 1 do
    let(:record) { create(:membership) }
    let(:record_url) { "/v1/memberships/#{record.id}" }
    let(:record_permission) { 'membership.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
