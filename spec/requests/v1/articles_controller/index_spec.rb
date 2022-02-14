require 'rails_helper'

describe V1::ArticlesController do
  describe 'GET /articles', version: 1 do
    let(:records) do
      [
        create(:article, :public),
        create(:article)
      ]
    end
    let(:record_url) { '/v1/articles' }
    let(:record_permission) { 'article.read' }

    before { Bullet.enable = false }

    after { Bullet.enable = true }

    subject(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[title content]

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :article }
    end
  end
end
