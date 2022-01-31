require 'rails_helper'

describe V1::MembershipsController do
  describe 'GET /memberships', version: 1 do
    let(:records) { create_list(:membership, 3) }
    let(:record_url) { '/v1/memberships' }
    let(:record_permission) { 'membership.read' }

    subject(:request) { get(record_url) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated and with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like 'a filterable model'
      it_behaves_like 'an indexable model'
    end
  end
end
