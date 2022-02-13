require 'rails_helper'

describe V1::BooksController do
  describe 'GET /books', version: 1 do
    let(:records) { create_list(:book, 3) }
    let(:record_url) { '/v1/books' }
    let(:record_permission) { 'book.read' }

    subject(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[title author description]
  end
end
