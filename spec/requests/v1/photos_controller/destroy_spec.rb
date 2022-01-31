require 'rails_helper'

describe V1::PhotosController do
  describe 'DELETE /photos/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:photo) }
      let(:record_url) { "/v1/photos/#{record.id}" }
      let(:record_permission) { 'photo.destroy' }
    end
  end
end
