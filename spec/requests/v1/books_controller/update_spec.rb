require 'rails_helper'

describe V1::BooksController do
  describe 'PUT /books/:id', version: 1 do
    let(:record) { create(:book) }
    let(:record_url) { "/v1/books/#{record.id}" }
    let(:record_permission) { 'book.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
