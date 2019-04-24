require 'rails_helper'

RSpec.describe PermissionsUsers, type: :model do
  subject(:permissions_users) { FactoryBot.build(:permissions_users) }

  describe '#valid?' do
    it { expect(permissions_users).to be_valid }

    context 'when without a user' do
      subject(:permissions_users) { FactoryBot.build_stubbed(:permissions_users, user: nil) }

      it { expect(permissions_users).not_to be_valid }
    end

    context 'when without a permission' do
      subject(:permissions_users) { FactoryBot.build_stubbed(:permissions_users, permission: nil) }

      it { expect(permissions_users).not_to be_valid }
    end
  end
end
