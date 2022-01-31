require 'rails_helper'

describe V1::ArticlesController do
  describe 'POST /articles/:id', version: 1 do
    let(:record) { build_stubbed(:article) }
    let(:record_url) { '/v1/articles' }
    let(:record_permission) { 'article.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'a creatable model with group'
    it_behaves_like 'a creatable model with author'
  end
end
