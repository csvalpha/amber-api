require 'rails_helper'

describe V1::ArticleCommentsController do
  describe 'DELETE /article_comments/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:article_comment) }
      let(:record_url) { "/v1/article_comments/#{record.id}" }
      let(:record_permission) { 'article_comment.destroy' }
    end
  end
end
