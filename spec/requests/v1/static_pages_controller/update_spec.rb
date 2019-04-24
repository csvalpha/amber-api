require 'rails_helper'

describe V1::StaticPagesController do
  describe 'PUT /static_pages/:slug', version: 1 do
    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:record) { FactoryBot.create(:static_page) }
      let(:record_url) { "/v1/static_pages/#{record.id}" }
      let(:record_permission) { 'static_page.update' }
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
