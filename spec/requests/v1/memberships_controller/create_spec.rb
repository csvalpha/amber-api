require 'rails_helper'

describe V1::MembershipsController do
  describe 'POST /memberships', version: 1 do
    let(:record) do
      build(:membership, group: create(:group),
                         user: create(:user))
    end
    let(:record_url) { '/v1/memberships' }
    let(:record_permission) { 'membership.create' }
    let(:valid_attributes) { record.attributes }

    it_behaves_like 'a creatable and permissible model' do
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

    describe 'when start date is not given' do
      let(:record) do
        build(:membership, start_date: nil,
                           group: create(:group),
                           user: create(:user))
      end
      let(:valid_relationships) do
        {
          group: { data: { id: record.group_id, type: 'groups' } },
          user: { data: { id: record.user_id, type: 'users' } }
        }
      end
      let(:valid_request) do
        post(record_url,
             data: {
               id: record.id,
               type: record_type(record),
               attributes: valid_attributes,
               relationships: valid_relationships
             })
      end

      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { valid_request }

      it_behaves_like '201 Created'
      it 'contains a default start-date' do
        expect(json['data']['attributes']['start_date']).not_to be_nil
      end
    end

    describe 'when the group is not given' do
      include_context 'when authenticated'

      let(:record) { build(:membership, group: nil, user: create(:user)) }
      let(:invalid_attributes) { record.attributes }
      let(:invalid_relationships) do
        {
          group: { data: nil },
          user: { data: { id: record.user_id, type: 'users' } }
        }
      end
      let(:invalid_request) do
        post(record_url,
             data: {
               id: record.id,
               type: record_type(record),
               attributes: invalid_attributes,
               relationships: invalid_relationships
             })
      end

      subject(:request) { invalid_request }

      it_behaves_like '403 Forbidden'

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) { create(:user, user_permission_list: [record_permission]) }
        end

        it_behaves_like '422 Unprocessable Entity'
      end
    end
  end
end
