require 'rails_helper'

describe V1::PhotoTagsController do
  describe 'DELETE /photo_tags/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:photo_tag) }
      let(:record_url) { "/v1/photo_tags/#{record.id}" }
      let(:record_permission) { 'photo_tag.destroy' }
    end
  end
end
