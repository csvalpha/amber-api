require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'POST /photo_albums', version: 1 do
    let(:record) { create(:photo_album) }
    let(:record_url) { '/v1/photo_albums' }
    let(:record_permission) { 'photo_album.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'a creatable model with group'
    it_behaves_like 'a creatable model with author'
  end
end
