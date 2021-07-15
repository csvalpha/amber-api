require 'rails_helper'

RSpec.describe PhotoAlbumPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build(:user) }

  permissions :update? do
    describe 'when photo album is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:photo_album)) }
    end

    describe 'when photo_album is owned' do
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:photo_album, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'photo_album.update' }
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:photo_album)) }
    end
  end
end
