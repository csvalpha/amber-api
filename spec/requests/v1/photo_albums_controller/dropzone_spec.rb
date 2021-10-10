require 'rails_helper'

describe V1::PhotoAlbumsController do
  describe 'POST /photo_albums/:id/dropzone', version: 1 do
    let(:record_url) { "/v1/photo_albums/#{record.photo_album.id}/dropzone" }
    let(:record_permission) { 'photo.create' }

    it_behaves_like 'a creatable and permissible model',
                    incorrect_data_response_behaves_like:
                    '422 Unprocessable Entity in Plain Text' do
      let(:record) { FactoryBot.create(:photo) }
      let(:valid_request) do
        post(record_url, file: FactoryBot.attributes_for(:photo)[:image])
      end
      let(:invalid_request) do
        post(record_url, file: nil)
      end
    end

    describe 'when using a too large large photo' do
      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
        end

        let(:record) do
          FactoryBot.build(:photo, :invalid, photo_album: FactoryBot.create(:photo_album))
        end
        let(:request) do
          post(record_url, file: FactoryBot.attributes_for(:photo, :invalid)[:image])
        end

        it { expect(request.status).to eq(422) }
        it { expect(request.body).to eq 'Afbeelding mag niet groter zijn dan 8192 x 8192' }
      end
    end
  end
end
