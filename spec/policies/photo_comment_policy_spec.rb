require 'rails_helper'

RSpec.describe PhotoCommentPolicy, type: :policy do
  subject(:policy) { described_class.new(nil, nil) }

  let(:user) { build(:user) }

  describe '#create_with_photo?' do
    it { expect(policy.create_with_photo?(nil)).to be true }
  end

  describe '#replace_photo?' do
    it { expect(policy.replace_photo?(nil)).to be true }
  end

  describe PhotoCommentPolicy::Scope do
    subject(:comments) { described_class.new(user, PhotoComment).resolve }

    let!(:public_comment) { create(:photo_comment, :public) }
    let!(:old_comment) do
      create(:photo_comment, photo: create(:photo, photo_album: create(:photo_album, date: 10.years.ago)))
    end
    let!(:recent_comment) do
      create(:photo_comment, photo: create(:photo, photo_album: create(:photo_album, date: 1.month.ago)))
    end

    context 'when not authenticated' do
      let(:user) { nil }

      it { expect(comments).to be_empty }
    end

    context 'when without read permission' do
      let(:user) { create(:user) }

      it { expect(comments).to be_empty }
    end

    context 'when with read permission but never a member' do
      let(:user) { create(:user, user_permission_list: %w[photo_comment.read]) }

      it { expect(comments).to contain_exactly(public_comment) }
    end

    context 'when a current member' do
      let(:user) { create(:user, user_permission_list: %w[photo_comment.read]) }

      before { create(:membership, user:, group: create(:group, name: 'Leden'), start_date: 1.year.ago) }

      it { expect(comments).to contain_exactly(public_comment, old_comment, recent_comment) }
    end

    context 'when a former member' do
      let(:user) { create(:user, user_permission_list: %w[photo_comment.read]) }

      before do
        create(:membership, user:, group: create(:group, name: 'Leden'), start_date: 2.years.ago, end_date: 1.month.ago)
      end

      it { expect(comments).to contain_exactly(public_comment, recent_comment) }
    end
  end
end
