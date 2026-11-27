require 'rails_helper'

RSpec.describe PhotoPolicy, type: :policy do
  subject(:policy) { described_class.new(nil, nil) }

  describe '#get_related_resources?' do
    it { expect(policy.get_related_resources?).to be true }
  end

  describe PhotoPolicy::Scope do
    subject(:photos) { described_class.new(user, Photo).resolve }

    let!(:public_photo) { create(:photo, photo_album: create(:photo_album, :public)) }
    let!(:old_photo) { create(:photo, photo_album: create(:photo_album, date: 10.years.ago)) }
    let!(:recent_photo) { create(:photo, photo_album: create(:photo_album, date: 1.month.ago)) }

    context 'when not authenticated' do
      let(:user) { nil }

      it { expect(photos).to contain_exactly(public_photo) }
    end

    context 'when with photo read permission and update permission on photo albums' do
      let(:user) { create(:user, user_permission_list: %w[photo.read photo_album.update]) }

      it { expect(photos).to contain_exactly(public_photo, old_photo, recent_photo) }
    end

    context 'when a former member' do
      let(:user) { create(:user, user_permission_list: %w[photo.read]) }

      before do
        create(:membership, user:, group: create(:group, name: 'Leden'), start_date: 2.years.ago, end_date: 1.month.ago)
      end

      it { expect(photos).to contain_exactly(public_photo, recent_photo) }
    end
  end
end
