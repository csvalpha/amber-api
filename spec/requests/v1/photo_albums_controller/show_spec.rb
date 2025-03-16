require 'rails_helper'

describe V1::PhotoAlbumsController do
  let(:user) { create(:user) }
  let(:group) { create(:group, name: 'Leden') }
  let(:membership) { create(:membership, user: user, group: group, start_date: 2.years.ago, end_date: nil) }
  let(:record) { create(:photo_album) }
  
  before do
    membership
  end

  describe 'GET /photo_albums/:id', version: 1 do
    let(:record) { create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}" }
    let(:record_permission) { 'photo_album.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a publicly visible model' do
      let(:public_record) { create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}" }
    end
  end
end
