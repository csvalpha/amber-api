require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'PUT /photo_albums/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { FactoryBot.create(:photo_album) }
      let(:record_url) { "/v1/photo_albums/#{record.id}" }
      let(:record_permission) { 'photo_album.update' }
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
