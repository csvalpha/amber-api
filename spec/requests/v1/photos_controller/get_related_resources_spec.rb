require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photo-albums/:id/photos', version: 1 do
    let(:record) { FactoryBot.create(:photo_album) }
    let(:public_record) { FactoryBot.create(:photo_album, :public) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/photos" }
    let(:record_permission) { 'photo_album.read' }

    it_behaves_like 'a publicly visible model' do
      let(:public_record) { FactoryBot.create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}/photos" }
    end
  end
end
