require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'POST /photo_albums', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { FactoryBot.create(:photo_album) }
      let(:record_url) { '/v1/photo_albums' }
      let(:record_permission) { 'photo_album.create' }
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
