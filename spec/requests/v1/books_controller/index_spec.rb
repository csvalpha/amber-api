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

  describe 'GET /books/isbn_lookup', version: 1 do
    let(:record_url) { '/v1/books/isbn_lookup' }
    let(:record_permission) { 'book.create' }
    let(:request) do
      VCR.use_cassette('retrieve_book_by_isbn') do
        get "#{record_url}?isbn=9781784870140"
      end
    end

    context 'when unauthorized' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user) }
      end

      it_behaves_like '403 Forbidden'
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      describe 'with subtitle' do
        it_behaves_like '200 OK'
      end

      # Commented because the isbn_lookup using bol.com is currently broken due
      # to an expired API key problem, making acquiring a cassette for this test
      # not possible. Work will be done in another PR on rewriting the
      # isbn_lookup to use the Google Books API.
      # describe 'without subtitle' do
      #   let(:request) do
      #     VCR.use_cassette('retrieve_book_by_isbn_no_subtitle') do
      #       get "#{record_url}?isbn=8713638034201"
      #     end
      #   end

      #   it_behaves_like '200 OK'
      # end
    end
  end
end
