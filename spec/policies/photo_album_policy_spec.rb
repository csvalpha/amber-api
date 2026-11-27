require 'rails_helper'

RSpec.describe PhotoAlbumPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when photo album is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:photo_album)) }
    end

    describe 'when photo_album is owned' do
      it { expect(policy).to permit(user, build_stubbed(:photo_album, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'photo_album.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:photo_album)) }
    end
  end

  describe PhotoAlbumPolicy::Scope do
    subject(:albums) { described_class.new(user, PhotoAlbum).resolve }

    let(:leden) { create(:group, name: 'Leden') }
    let(:user) { create(:user, user_permission_list: %w[photo_album.read]) }

    let!(:public_album) { create(:photo_album, :public, date: 10.years.ago) }
    let!(:alumni_album) { create(:photo_album, :alumni, date: 10.years.ago) }
    let!(:old_album) { create(:photo_album, date: 10.years.ago) }
    let!(:recent_album) { create(:photo_album, date: 1.month.ago) }

    context 'when not authenticated' do
      let(:user) { nil }

      it { expect(albums).to contain_exactly(public_album) }
    end

    context 'when without read permission' do
      let(:user) { create(:user) }

      it { expect(albums).to contain_exactly(public_album) }
    end

    context 'when with read permission but never a member' do
      it { expect(albums).to contain_exactly(public_album) }
    end

    context 'when with update permission' do
      let(:user) { create(:user, user_permission_list: %w[photo_album.read photo_album.update]) }

      it { expect(albums).to contain_exactly(public_album, alumni_album, old_album, recent_album) }
    end

    context 'when a current member' do
      before { create(:membership, user:, group: leden, start_date: 1.year.ago, end_date: nil) }

      it { expect(albums).to contain_exactly(public_album, alumni_album, old_album, recent_album) }
    end

    context 'when a member whose membership ends in the future' do
      before { create(:membership, user:, group: leden, start_date: 1.year.ago, end_date: 1.month.from_now) }

      it { expect(albums).to contain_exactly(public_album, alumni_album, old_album, recent_album) }
    end

    context 'when a former member' do
      let!(:album_before_membership) { create(:photo_album, date: 7.years.ago) }
      let!(:album_after_membership) { create(:photo_album, date: 3.years.ago - 5.months) }

      before { create(:membership, user:, group: leden, start_date: 6.years.ago, end_date: 3.years.ago) }

      it 'sees public and alumni albums and members albums from 18 months before to 6 months after' do
        expect(albums).to contain_exactly(public_album, alumni_album, album_before_membership, album_after_membership)
      end
    end

    context 'when a former member with multiple memberships' do
      before do
        create(:membership, user:, group: leden, start_date: 11.years.ago, end_date: 9.years.ago)
        create(:membership, user:, group: leden, start_date: 5.years.ago, end_date: 2.years.ago)
      end

      it { expect(albums).to contain_exactly(public_album, alumni_album, old_album) }
    end

    context 'when only a member of another group' do
      before { create(:membership, user:, start_date: 1.year.ago, end_date: nil) }

      it { expect(albums).to contain_exactly(public_album) }
    end
  end
end
