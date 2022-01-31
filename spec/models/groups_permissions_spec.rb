require 'rails_helper'

RSpec.describe GroupsPermissions, type: :model do
  subject(:groups_permissions) { build_stubbed(:groups_permissions) }

  describe '#valid?' do
    it { expect(groups_permissions.valid?).to be true }

    context 'when without a group' do
      subject(:groups_permissions) { build_stubbed(:groups_permissions, group: nil) }

      it { expect(groups_permissions.valid?).to be false }
    end

    context 'when without a permission' do
      subject(:groups_permissions) do
        build_stubbed(:groups_permissions, permission: nil)
      end

      it { expect(groups_permissions.valid?).to be false }
    end
  end
end
