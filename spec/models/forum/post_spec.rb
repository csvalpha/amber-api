require 'rails_helper'

RSpec.describe Forum::Post, type: :model do
  subject(:post) { build_stubbed(:post) }

  describe '#valid' do
    it { expect(post.valid?).to be true }

    context 'when without a message' do
      subject(:post) { build_stubbed(:post, message: nil) }

      it { expect(post.valid?).to be false }
    end

    context 'when without an author' do
      subject(:post) { build_stubbed(:post, author: nil) }

      it { expect(post.valid?).to be false }
    end

    context 'when without a thread' do
      subject(:post) { build_stubbed(:post, thread: nil) }

      it { expect(post.valid?).to be false }
    end
  end

  describe '#save' do
    context 'when it updates' do
      subject(:post) { create(:post) }

      before { post.message = post.message += '_updated' }

      it { expect { post.save }.to(change { post.thread.updated_at }) }
      it { expect { post.save }.to(change { post.thread.category.updated_at }) }
    end
  end
end
