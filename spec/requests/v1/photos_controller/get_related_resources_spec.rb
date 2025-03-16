require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photo-albums/:id/photos', version: 1 do
    let(:records) { create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/photos" }
    let(:record_permission) { 'photo_album.read' }

    it_behaves_like 'an indexable model'
  end
end
