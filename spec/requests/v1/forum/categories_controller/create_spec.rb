require 'rails_helper'

describe V1::Forum::CategoriesController do
  describe 'POST /forum/categories', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { FactoryBot.build(:category) }
      let(:record_url) { '/v1/forum/categories' }
      let(:record_permission) { 'forum/category.create' }
      let(:invalid_attributes) { { name: '' } }
    end
  end
end
