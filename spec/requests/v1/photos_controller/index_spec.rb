require 'rails_helper'

describe V1::PhotosController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: nil) }
  let(:records) { create_list(:photo, 3) }

  before do
    membership
  end

  describe 'GET /photos', version: 1 do
    let(:record_url) { '/v1/photos' }
    let(:record_permission) { 'photo.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
  end
end
