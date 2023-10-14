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

    describe 'filters' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      let(:filtered_request) do
        get("#{record_url}?filter[administrative]=true")
      end

      let(:administrative_group) { create(:group, administrative: true) }
      let(:new_records) do
        records + [administrative_group]
      end
      let(:expected_ids) { [administrative_group.id] }

      subject(:request) { filtered_request }

      before do
        administrative_group
      end
      
      it_behaves_like '200 OK'

      it { expect(json_object_ids).to match_array(expected_ids) }
      it { expect(json_object_ids.count).to equal(1) }
      it { expect(json_object_ids).to include(administrative_group.id) }
      it { expect(json_object_ids).not_to include(records[0].id) }
      it { expect(json_object_ids).not_to include(records[1].id) }
    end
  end
end
