require 'rails_helper'

describe V1::Forum::CategoriesController do
  describe 'GET /forum/categories/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:category) }
      let(:record_url) { "/v1/forum/categories/#{record.id}" }
      let(:record_permission) { 'forum/category.read' }
    end
  end
end
