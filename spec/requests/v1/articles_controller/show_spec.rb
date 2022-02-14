require 'rails_helper'

describe V1::ArticlesController do
  describe 'GET /articles/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:article) }
    let(:record_url) { "/v1/articles/#{record.id}" }
    let(:record_permission) { 'article.read' }
    let(:public_record) { create(:article, :public) }
    let(:public_record_url) { "/v1/articles/#{public_record.id}" }

    it_behaves_like 'a publicly visible model'
  end
end
