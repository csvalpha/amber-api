require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photos/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:photo) }
      let(:record_url) { "/v1/photos/#{record.id}" }
      let(:record_permission) { 'photo.read' }
    end
  end
end
