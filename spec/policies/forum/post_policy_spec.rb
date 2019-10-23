require 'rails_helper'

RSpec.describe Forum::PostPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:thread) { FactoryBot.build_stubbed(:thread) }
  let(:closed_thread) { FactoryBot.build_stubbed(:thread, :closed) }

  describe '#create_with_thread?' do
    it { expect(policy.new(nil, nil).create_with_thread?(nil)).to be true }
  end

  describe '#replace_author?' do
    it { expect(policy.new(nil, nil).replace_thread?(nil)).to be true }
  end

  permissions :create?, :update? do
    it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:post, thread: thread)) }

    it do
      expect(policy).not_to permit(user, FactoryBot.build_stubbed(:post, thread: closed_thread))
    end
  end

  permissions :create? do
    describe 'when with permission' do
      let(:user) { FactoryBot.create(:user, user_permission_list: ['forum/post.create']) }

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: thread)) }

      it do
        expect(policy).not_to permit(user, FactoryBot.build_stubbed(:post,
                                                                    thread: closed_thread))
      end
    end

    describe 'when with forum/thread.update and forum/post.create permission' do
      let(:user) do
        FactoryBot.create(:user,
                          user_permission_list: ['forum/thread.update', 'forum/post.create'])
      end

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: thread)) }
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: closed_thread)) }
    end
  end

  permissions :update? do
    describe 'when with permission' do
      let(:user) { FactoryBot.create(:user, user_permission_list: ['forum/post.update']) }

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: thread)) }

      it do
        expect(policy).not_to permit(user, FactoryBot.build_stubbed(:post, thread: closed_thread))
      end
    end

    describe 'when with forum/thread.update and forum/post.create permission' do
      let(:user) do
        FactoryBot.create(:user,
                          user_permission_list: ['forum/thread.update', 'forum/post.update'])
      end

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: thread)) }
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, thread: closed_thread)) }
    end

    describe 'when post is owned' do
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:post, author: user)) }
    end
  end
end
