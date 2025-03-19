require 'rails_helper'

describe V1::GroupsController do
  describe 'PUT /groups/:id', version: 1 do
    let(:record) { create(:group) }
    let(:record_url) { "/v1/groups/#{record.id}" }
    let(:record_permission) { 'group.update' }

    subject(:request) { put(record_url) }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { name: '' } }
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      unrestricted_attributes = %i[description avatar]
      permissible_attributes = %i[name recognized_at_gma rejected_at_gma administrative]
      it_behaves_like 'a model with conditionally updatable attributes',
                      unrestricted_attributes, permissible_attributes, :ok do
        let(:record) { create(:group) }
        let(:record_url) { "/v1/groups/#{record.id}" }
        let(:override_attrs) { { kind: attributes_for(:group)[:kind] } }
        let(:record_permission) { 'group.update' }

        before do
          create(:membership, user:, group: record)
        end
      end
    end
  end
end
