require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums/:id', version: 1 do
    let(:record) { create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}" }
    let(:record_permission) { 'photo_album.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a publicly visible model' do
      include_context 'when member'

      let(:public_record) { create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}" }
    end

    context 'when alumni' do
      include_context 'when alumni'

      context 'with a members album from around their membership' do
        let(:record) { create(:photo_album, date: 5.years.ago) }

        it_behaves_like '200 OK'
      end

      context 'with a recent alumni album' do
        let(:record) { create(:photo_album, :alumni, date: 1.month.ago) }

        it_behaves_like '200 OK'
      end

      context 'with a recent members album' do
        let(:record) { create(:photo_album, date: 1.month.ago) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
