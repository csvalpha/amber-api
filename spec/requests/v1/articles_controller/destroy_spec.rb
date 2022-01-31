require 'rails_helper'

describe V1::ArticlesController do
  describe 'DELETE /articles/:id', version: 1 do
    let(:record) { create(:article) }
    let(:record_url) { "/v1/articles/#{record.id}" }
    let(:record_permission) { 'article.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
