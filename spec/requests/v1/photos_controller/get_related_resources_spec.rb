require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photo-albums/:id/photos', version: 1 do
    let(:record) { create(:photo_album) }
    let(:public_record) { create(:photo_album, :public) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/photos" }
    let(:record_permission) { 'photo_album.read' }
  end
end
