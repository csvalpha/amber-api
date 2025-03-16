require 'rails_helper'

describe V1::PhotosController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: nil) }
  let(:record) { create(:photo) }

  before do
    membership
  end

  describe 'GET /photos/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record_url) { "/v1/photos/#{record.id}" }
      let(:record_permission) { 'photo.read' }
    end
  end
end
