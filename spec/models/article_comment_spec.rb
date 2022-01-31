require 'rails_helper'

RSpec.describe ArticleComment, type: :model do
  subject(:article_comment) { build(:article_comment) }

  describe '#valid?' do
    it { expect(article_comment.valid?).to be true }

    context 'when with an empty content' do
      subject(:article_comment) { build(:article_comment, content: '') }

      it { expect(article_comment.valid?).to be false }
    end

    context 'when with a too long content' do
      subject(:article_comment) do
        build(:article_comment, content: Faker::Lorem.characters(number: 501))
      end

      it { expect(article_comment.valid?).to be false }
    end

    context 'when without an article' do
      subject(:article_comment) { build(:article_comment, article: nil) }

      it { expect(article_comment.valid?).to be false }
    end

    context 'when without an author' do
      subject(:article_comment) { build(:article_comment, author: nil) }

      it { expect(article_comment.valid?).to be false }
    end
  end

  describe '#publicly_visible' do
    let(:public_article) { create(:article, publicly_visible: true) }
    let(:private_article) { create(:article, publicly_visible: false) }

    before do
      create(:article_comment, article: public_article)
      create(:article_comment, article: public_article)
      create(:article_comment, article: private_article)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end
end
