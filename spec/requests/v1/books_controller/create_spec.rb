require 'rails_helper'

describe V1::BooksController do
  describe 'POST /books/:id', version: 1 do
    let(:record) { build_stubbed(:book) }
    let(:record_url) { '/v1/books' }
    let(:record_permission) { 'book.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end
  end
end
