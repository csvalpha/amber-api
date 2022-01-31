require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photos/:id', version: 1 do
    let(:record) { create(:photo) }
    let(:record_url) { "/v1/photos/#{record.id}" }
    let(:public_record) { create(:photo, :public) }
    let(:public_record_url) { "/v1/photos/#{public_record.id}" }
    let(:record_permission) { 'photo.read' }

    it_behaves_like 'a publicly visible model'
  end
end
