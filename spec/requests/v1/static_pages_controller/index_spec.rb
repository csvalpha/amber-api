require 'rails_helper'

describe V1::StaticPagesController do
  describe 'GET /static_pages', version: 1 do
    let(:records) do
      [
        create(:static_page),
        create(:static_page),
        create(:static_page, :public)
      ]
    end
    let(:record_url) { '/v1/static_pages' }
    let(:record_permission) { 'static_page.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[title content]

    it_behaves_like 'a publicly visible index request' do
      let(:model_name) { :static_page }
    end
  end
end
