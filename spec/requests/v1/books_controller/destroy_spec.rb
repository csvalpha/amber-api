require 'rails_helper'

describe V1::BooksController do
  describe 'DELETE /books/:id', version: 1 do
    let(:record) { create(:book) }
    let(:record_url) { "/v1/books/#{record.id}" }
    let(:record_permission) { 'book.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
