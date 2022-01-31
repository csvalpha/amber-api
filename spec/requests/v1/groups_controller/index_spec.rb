require 'rails_helper'

describe V1::GroupsController do
  describe 'GET /groups', version: 1 do
    let(:records) { create_list(:group, 3) }
    let(:record_url) { '/v1/groups' }
    let(:record_permission) { 'group.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[name]

    describe 'conditionally serializable attributes' do
      context 'when authenticated' do
        include_context 'when authenticated' do
          let(:user) { create(:user, user_permission_list: [record_permission]) }
        end
        before do
          records
          request
        end

        it_behaves_like '200 OK'
        it {
          expect(json['data'][0]['attributes'].keys).to match_array(
            %w[name description description_camofied kind recognized_at_gma rejected_at_gma
               administrative avatar_thumb_url avatar_url created_at updated_at]
          )
        }
      end
    end
  end
end
