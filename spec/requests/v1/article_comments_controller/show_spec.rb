require 'rails_helper'

describe V1::ArticleCommentsController do
  describe 'GET /article_comments/:id', version: 1 do
    let(:record) { FactoryBot.create(:article_comment) }
    let(:record_url) { "/v1/article_comments/#{record.id}" }
    let(:public_record) { FactoryBot.create(:article_comment, :with_public_article) }
    let(:public_record_url) { "/v1/article_comments/#{public_record.id}" }
    let(:record_permission) { 'article_comment.read' }

    it_behaves_like 'a publicly visible model'

    # it_behaves_like 'a json response includes user' do
    #   let(:record_url) { public_record_url }
    # end
  end
end
