require 'rails_helper'

describe V1::PhotoTagsController do
  describe 'GET /photo_tags', version: 1 do
    let(:records) { create_list(:photo_tag, 3) }
    let(:record_url) { '/v1/photo_tags' }
    let(:record_permission) { 'photo_tag.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
