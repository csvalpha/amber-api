require 'rails_helper'

describe V1::StaticPagesController do
  describe 'POST /static_pages/:id', version: 1 do
    let(:record) { FactoryBot.build_stubbed(:static_page) }
    let(:record_url) { '/v1/static_pages' }
    let(:record_permission) { 'static_page.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
