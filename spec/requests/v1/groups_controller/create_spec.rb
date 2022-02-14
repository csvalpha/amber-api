require 'rails_helper'

describe V1::GroupsController do
  describe 'POST /groups', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { build(:group) }
      let(:record_url) { '/v1/groups' }
      let(:record_permission) { 'group.create' }
      let(:invalid_attributes) { { name: '' } }
    end
  end
end
