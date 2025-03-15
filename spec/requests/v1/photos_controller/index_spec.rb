require 'rails_helper'

describe V1::PhotosController do
  describe 'GET /photos', version: 1 do
    let(:records) { create_list(:photo, 3) }
    let(:record_url) { '/v1/photos' }
    let(:record_permission) { 'photo.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
  end
end
