require 'rails_helper'

describe V1::PhotoCommentsController do
  describe 'GET /photo_comments/:id', version: 1 do
    let(:record) { FactoryBot.create(:photo_comment) }
    let(:record_url) { "/v1/photo_comments/#{record.id}" }
    let(:public_record) { FactoryBot.create(:photo_comment, :public) }
    let(:public_record_url) { "/v1/photo_comments/#{public_record.id}" }
    let(:record_permission) { 'photo_comment.read' }

    it_behaves_like 'a publicly visible model'
  end
end
