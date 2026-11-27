require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photos/:id', version: 1 do
    let(:record) { create(:photo) }
    let(:record_url) { "/v1/photos/#{record.id}" }
    let(:record_permission) { 'photo.read' }

    subject(:request) { get(record_url) }

    context 'when not authenticated' do
      let(:record) { create(:photo, :public) }

      it_behaves_like '401 Unauthorized'
    end

    context 'when member' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end
      include_context 'when member'

      it_behaves_like '200 OK'
    end

    context 'when authenticated without a membership' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      it_behaves_like '403 Forbidden'

      context 'with a public photo' do
        let(:record) { create(:photo, :public) }

        it_behaves_like '200 OK'
      end
    end

    context 'when alumni' do
      include_context 'when alumni'

      context 'with a photo from around their membership' do
        let(:record) { create(:photo, photo_album: create(:photo_album, date: 5.years.ago)) }

        it_behaves_like '200 OK'
      end

      context 'with a recent photo' do
        let(:record) { create(:photo, photo_album: create(:photo_album, date: 1.month.ago)) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
