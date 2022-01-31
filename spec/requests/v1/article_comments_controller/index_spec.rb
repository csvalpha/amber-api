require 'rails_helper'

describe V1::ArticleCommentsController do
  describe 'GET /article_comments', version: 1 do
    let(:records) { create_list(:article_comment, 3) }
    let(:record_url) { '/v1/article_comments' }
    let(:record_permission) { 'article_comment.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :article_comment }
      let(:public_record) { create(:article_comment, :with_public_article) }
    end
  end
end
