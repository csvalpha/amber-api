require 'rails_helper'

describe V1::GroupsController do
  describe 'GET /groups/:id', version: 1 do
    let(:record) { FactoryBot.create(:group) }
    let(:record_url) { "/v1/groups/#{record.id}" }
    let(:record_permission) { 'group.read' }

    it_behaves_like 'a permissible model'
  end
end
