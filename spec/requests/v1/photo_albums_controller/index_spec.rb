require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums', version: 1 do
    let(:records) { FactoryBot.create_list(:photo_album, 3) }
    let(:record_url) { '/v1/photo_albums' }
    let(:record_permission) { 'photo_album.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :photo_album }
    end

    it_behaves_like 'a searchable model', %i[title]
  end
end
