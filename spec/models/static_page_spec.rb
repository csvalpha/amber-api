require 'rails_helper'

RSpec.describe StaticPage, type: :model do
  subject(:static_page) { build_stubbed(:static_page) }

  describe '#valid' do
    it { expect(static_page).to be_valid }

    context 'when without a title' do
      subject(:static_page) { build_stubbed(:static_page, title: nil) }

      it { expect(static_page).not_to be_valid }
    end

    context 'when without content' do
      subject(:static_page) { build_stubbed(:static_page, content: nil) }

      it { expect(static_page).not_to be_valid }
    end

    context 'when without public visibility' do
      subject(:static_page) { build_stubbed(:static_page, publicly_visible: nil) }

      it { expect(static_page).not_to be_valid }
    end

    context 'when without category' do
      subject(:static_page) { build_stubbed(:static_page, category: nil) }

      it { expect(static_page).not_to be_valid }
    end

    context 'when without a valid category' do
      subject(:static_page) { build_stubbed(:static_page, category: 'wrong!') }

      it { expect(static_page).not_to be_valid }
    end
  end

  describe '#find' do
    subject(:static_page) { create(:static_page) }

    it { expect(described_class.find(static_page.slug)).to eq static_page }
  end

  describe '#save' do
    subject(:static_page) { build(:static_page) }

    it do
      expect { static_page.save }.to(change(static_page, :slug).from(nil)
        .to(static_page.title.parameterize))
    end
  end

  describe '#publicly_visible' do
    before do
      create(:static_page, publicly_visible: true)
      create(:static_page, publicly_visible: true)
      create(:static_page, publicly_visible: false)
    end

    it { expect(described_class.publicly_visible.count).to be 2 }
    it { expect(described_class.count - described_class.publicly_visible.count).to be 1 }
  end
end
