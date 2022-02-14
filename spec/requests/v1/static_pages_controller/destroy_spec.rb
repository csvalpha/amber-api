require 'rails_helper'

describe V1::StaticPagesController do
  describe 'DELETE /static_pages/:slug', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { create(:static_page) }
      let(:record_url) { "/v1/static_pages/#{record.slug}" }
      let(:record_permission) { 'static_page.destroy' }
    end
  end
end
