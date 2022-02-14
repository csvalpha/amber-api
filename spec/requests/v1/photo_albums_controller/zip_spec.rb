require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums/:id/zip', version: 1 do
    let(:record) { create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/zip" }
    let(:record_permission) { 'photo.read' }
    let(:request) { get(record_url) }

    before { record }

    include_context 'when authenticated' do
      let(:user) { create(:user, user_permission_list: [record_permission]) }
    end

    it_behaves_like '200 OK'
  end
end
