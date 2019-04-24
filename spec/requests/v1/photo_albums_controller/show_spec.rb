require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums/:id', version: 1 do
    let(:record) { FactoryBot.create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}" }
    let(:record_permission) { 'photo_album.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a publicly visible model' do
      let(:public_record) { FactoryBot.create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}" }
    end
  end
end
