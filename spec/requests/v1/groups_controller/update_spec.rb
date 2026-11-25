require 'rails_helper'

describe V1::GroupsController do
  describe 'PUT /groups/:id', version: 1 do
    let(:record) { create(:group) }
    let(:record_url) { "/v1/groups/#{record.id}" }
    let(:record_permission) { 'group.update' }

    subject(:request) { put(record_url) }

    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:invalid_attributes) { { name: '' } }
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like 'a model with conditionally updatable attributes',
                      %i[description avatar],
                      %i[name recognized_at_gma rejected_at_gma administrative], :ok do
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
