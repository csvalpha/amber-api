require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'PUT /photo_albums/:id', version: 1 do
    let(:record) { FactoryBot.create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}" }
    let(:record_permission) { 'photo_album.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'an updatable model with group'
  end
end
