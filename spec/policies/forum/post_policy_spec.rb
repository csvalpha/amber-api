require 'rails_helper'

RSpec.describe Forum::PostPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }
  let(:thread) { build_stubbed(:thread) }
  let(:closed_thread) { build_stubbed(:thread, :closed) }

  describe '#create_with_thread?' do
    it { expect(policy.new(nil, nil).create_with_thread?(nil)).to be true }
  end

  describe '#replace_author?' do
    it { expect(policy.new(nil, nil).replace_thread?(nil)).to be true }
  end

  permissions :create?, :update? do
    it { expect(policy).not_to permit(user, build_stubbed(:post, thread:)) }

    it do
      expect(policy).not_to permit(user, build_stubbed(:post, thread: closed_thread))
    end
  end

  permissions :create? do
    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: ['forum/post.create']) }

      it { expect(policy).to permit(user, build_stubbed(:post, thread:)) }

      it do
        expect(policy).not_to permit(user, build_stubbed(:post,
                                                         thread: closed_thread))
      end
    end

    describe 'when with forum/thread.update and forum/post.create permission' do
      let(:user) do
        create(:user,
               user_permission_list: ['forum/thread.update', 'forum/post.create'])
      end

      it { expect(policy).to permit(user, build_stubbed(:post, thread:)) }
      it { expect(policy).to permit(user, build_stubbed(:post, thread: closed_thread)) }
    end
  end

  permissions :update? do
    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: ['forum/post.update']) }

      it { expect(policy).to permit(user, build_stubbed(:post, thread:)) }

      it do
        expect(policy).not_to permit(user, build_stubbed(:post, thread: closed_thread))
      end
    end

    describe 'when with forum/thread.update and forum/post.create permission' do
      let(:user) do
        create(:user,
               user_permission_list: ['forum/thread.update', 'forum/post.update'])
      end

      it { expect(policy).to permit(user, build_stubbed(:post, thread:)) }
      it { expect(policy).to permit(user, build_stubbed(:post, thread: closed_thread)) }
    end

    describe 'when post is owned' do
      it { expect(policy).to permit(user, build_stubbed(:post, author: user)) }
    end
  end
end
