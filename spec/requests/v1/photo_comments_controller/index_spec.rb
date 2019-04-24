require 'rails_helper'

describe V1::PhotoCommentsController do
  describe 'GET /photo_comments', version: 1 do
    let(:records) { FactoryBot.create_list(:photo_comment, 3) }
    let(:record_url) { '/v1/photo_comments' }
    let(:record_permission) { 'photo_comment.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :photo_comment }
    end
  end
end
