require 'rails_helper'

describe V1::Forum::CategoriesController do
  describe 'GET /forum/categories', version: 1 do
    let(:records) { FactoryBot.create_list(:category, 3) }
    let(:record_url) { '/v1/forum/categories' }
    let(:record_permission) { 'forum/category.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'

    context 'search' do
      before { Bullet.enable = false }

      after { Bullet.enable = true }

      it_behaves_like 'a searchable model', %i[name]
    end
  end
end
