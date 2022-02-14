require 'rails_helper'

describe V1::Forum::CategoriesController do
  describe 'PUT /forum/categories/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:category) }
      let(:record_url) { "/v1/forum/categories/#{record.id}" }
      let(:record_permission) { 'forum/category.update' }
      let(:invalid_attributes) { { name: '' } }
    end
  end
end
