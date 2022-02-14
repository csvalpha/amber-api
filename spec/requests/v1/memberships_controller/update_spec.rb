require 'rails_helper'

describe V1::MembershipsController do
  describe 'PUT /memberships/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:membership) }
      let(:record_url) { "/v1/memberships/#{record.id}" }
      let(:record_permission) { 'membership.update' }
      let(:valid_attributes) { record.attributes }
      let(:valid_relationships) do
        {
          group: { data: { id: record.group_id, type: 'groups' } },
          user: { data: { id: record.user_id, type: 'users' } }
        }
      end
      let(:invalid_relationships) do
        {
          group: { data: { id: record.group_id, type: 'groups' } },
          user: { data: nil, type: 'users' }
        }
      end
    end
  end
end
