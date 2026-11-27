require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photos', version: 1 do
    let(:records) { create_list(:photo, 3) }
    let(:record_url) { '/v1/photos' }
    let(:record_permission) { 'photo.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model' do
      include_context 'when member'
    end

    context 'when not authenticated' do
      before { create(:photo, :public) }

      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated without a membership' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      let!(:public_photo) { create(:photo, :public) }

      before { records }

      it { expect(json_object_ids).to contain_exactly(public_photo.id) }
    end
  end
end
