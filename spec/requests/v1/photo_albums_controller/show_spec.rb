require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'GET /photo_albums/:id', version: 1 do
    let(:record_permission) { 'photo_album.read' }

    context 'when not publicly visible' do
      let(:record) { create(:photo_album) }
      let(:record_url) { "/v1/photo_albums/#{record.id}" }

      subject(:request) { get(record_url) }

      context 'when not authenticated' do
        it_behaves_like '403 Forbidden'
      end

      context 'when member' do
        include_context 'when member' do
          let(:user) { create(:user, user_permission_list: [record_permission]) }
        end

        before do
          membership
        end

        it_behaves_like '200 OK'
      end
    end

    context 'when publicly visible' do
      let(:public_record) { create(:photo_album, :public) }
      let(:public_record_url) { "/v1/photo_albums/#{public_record.id}" }

      subject(:request) { get(public_record_url) }

      context 'when not authenticated' do
        it_behaves_like '200 OK'
      end

      context 'when member' do
        include_context 'when member' do
          let(:user) { create(:user, user_permission_list: [record_permission]) }
        end

        before do
          membership
        end

        it_behaves_like '200 OK'
      end
    end
  end
end
