require 'rails_helper'

describe V1::PhotoCommentsController do
  describe 'GET /photo_comments/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:photo_comment) }
      let(:record_url) { "/v1/photo_comments/#{record.id}" }
      let(:record_permission) { 'photo_comment.read' }
    end
  end
end



