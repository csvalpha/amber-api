require 'rails_helper'

describe V1::PhotoTagsController do
  describe 'GET /photo_tags/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:photo_tag) }
      let(:record_url) { "/v1/photo_tags/#{record.id}" }
      let(:record_permission) { 'photo_tag.read' }
    end
  end
end
