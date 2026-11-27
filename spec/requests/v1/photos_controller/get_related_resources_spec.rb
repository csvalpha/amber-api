require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photo-albums/:id/photos', version: 1 do
    let(:record) { create(:photo_album) }
    let(:public_record) { create(:photo_album, :public) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/photos" }
    let(:record_permission) { 'photo_album.read' }

    it_behaves_like 'a publicly visible model' do
      include_context 'when member'

      let(:public_record) { create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}/photos" }
    end

    context 'when not authenticated and including comments' do
      subject(:request) { get("/v1/photo_albums/#{public_record.id}/photos?include=comments") }

      before { create(:photo_comment, photo: create(:photo, photo_album: public_record)) }

      it_behaves_like '200 OK'
      it { expect(json['included']).to be_blank }
    end
  end
end
