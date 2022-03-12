require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { build_stubbed(:book) }

  describe '#valid' do
    it { expect(book).to be_valid }

    context 'when without a title' do
      subject(:book) { build_stubbed(:book, title: nil) }

      it { expect(book).not_to be_valid }
    end

    context 'when with an invalid isbn' do
      subject(:book) { build_stubbed(:book, isbn: '123456789') }

      it { expect(book).not_to be_valid }
    end

    context 'when with a valid isbn' do
      subject(:book) { build_stubbed(:book, isbn: '9789065393746') }

      it { expect(book).to be_valid }
    end

    context 'when without a isbn' do
      subject(:book) { build_stubbed(:book, isbn: nil) }

      it { expect(book).to be_valid }
    end

    context 'when without an author' do
      subject(:book) { build_stubbed(:book, author: nil) }

      it { expect(book).to be_valid }
    end

    context 'when without a description' do
      subject(:book) { build_stubbed(:book, description: nil) }

      it { expect(book).to be_valid }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo
  end
end
