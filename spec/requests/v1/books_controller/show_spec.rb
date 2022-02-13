require 'rails_helper'

describe V1::BooksController do
  describe 'GET /books/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:book) }
    let(:record_url) { "/v1/books/#{record.id}" }
    let(:record_permission) { 'book.read' }

    it_behaves_like 'a permissible model'
  end
end
