require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { FactoryBot.build(:article) }

  describe '#valid' do
    it { expect(article).to be_valid }

    context 'when without a title' do
      subject(:article) { FactoryBot.build_stubbed(:article, title: nil) }

      it { expect(article).not_to be_valid }
    end

    context 'when without content' do
      subject(:article) { FactoryBot.build(:article, content: nil) }

      it { expect(article).not_to be_valid }
    end

    context 'when without an author' do
      subject(:article) { FactoryBot.build_stubbed(:article, author: nil) }

      it { expect(article).not_to be_valid }
    end

    context 'when without a group' do
      subject(:article) { FactoryBot.build_stubbed(:article, group: nil) }

      it { expect(article).to be_valid true }
    end

    context 'when without public visibility' do
      subject(:article) { FactoryBot.build(:article, publicly_visible: nil) }

      it { expect(article).not_to be_valid }
    end

    context 'when without pinned' do
      subject(:article) { FactoryBot.build(:article, pinned: nil) }

      it { expect(article).not_to be_valid }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :cover_photo
  end

  describe '#publicly_visible' do
    before do
      FactoryBot.create(:article, publicly_visible: true)
      FactoryBot.create(:article, publicly_visible: true)
      FactoryBot.create(:article, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end

  describe '#pinned' do
    context 'when other already pinned' do
      subject(:article) { FactoryBot.build(:article, pinned: true) }

      before { FactoryBot.create(:article, pinned: true) }

      it { expect(article).not_to be_valid }
    end

    context 'when none already pinned' do
      subject(:article) { FactoryBot.build(:article, pinned: true) }

      it { expect(article).to be_valid }
    end
  end

  describe '#owners' do
    it_behaves_like 'a model with group owners'
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :article_comment
  end
end
