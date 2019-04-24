require 'rails_helper'

describe V1::StaticPagesController do
  describe 'GET /static_pages/:slug', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { FactoryBot.create(:static_page) }
    let(:record_url) { "/v1/static_pages/#{record.slug}" }
    let(:public_record) { FactoryBot.create(:static_page, :public) }
    let(:public_record_url) { "/v1/static_pages/#{public_record.slug}" }
    let(:record_permission) { 'static_page.read' }

    it_behaves_like 'a publicly visible model'
  end
end
