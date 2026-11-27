require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums/:id/zip', version: 1 do
    let(:record) { create(:photo_album) }
    let(:record_url) { "/v1/photo_albums/#{record.id}/zip" }
    let(:record_permission) { 'photo_album.read' }
    let(:request) { get(record_url) }

    before { record }

    context 'when member' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end
      include_context 'when member'

      it_behaves_like '200 OK'
    end

    context 'when alumni' do
      include_context 'when alumni'

      context 'with a members album from around their membership' do
        let(:record) { create(:photo_album, date: 5.years.ago) }

        it_behaves_like '200 OK'
      end

      context 'with a recent members album' do
        let(:record) { create(:photo_album, date: 1.month.ago) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
