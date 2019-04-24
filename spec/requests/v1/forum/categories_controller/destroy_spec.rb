require 'rails_helper'

describe V1::Forum::CategoriesController do
  describe 'DELETE /forum/categories/:id', version: 1 do
    let(:record) { FactoryBot.create(:category) }
    let(:record_url) { "/v1/forum/categories/#{record.id}" }
    let(:record_permission) { 'forum/category.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
