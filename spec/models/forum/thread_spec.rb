require 'rails_helper'

RSpec.describe Forum::Thread, type: :model do
  subject(:thread) { build_stubbed(:thread) }

  describe '#valid' do
    it { expect(thread.valid?).to be true }

    context 'when without a title' do
      subject(:thread) { build_stubbed(:thread, title: nil) }

      it { expect(thread.valid?).to be false }
    end

    context 'when without an author' do
      subject(:thread) { build_stubbed(:thread, author: nil) }

      it { expect(thread.valid?).to be false }
    end

    context 'when without a category' do
      subject(:thread) { build_stubbed(:thread, category: nil) }

      it { expect(thread.valid?).to be false }
    end
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :post
  end

  describe 'it updates the category after save' do
    subject(:thread) { build(:thread) }

    it { expect { thread.save }.to(change { thread.category.updated_at }) }
  end
end
