require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'DELETE /photo_albums/:id', version: 1 do
    let(:record) { FactoryBot.create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}" }
    let(:record_permission) { 'photo_album.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
