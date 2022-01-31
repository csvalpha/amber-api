require 'rails_helper'

RSpec.describe Permission, type: :model do
  subject(:permission) { build_stubbed(:permission) }

  describe '#valid?' do
    it { expect(permission).to be_valid }

    context 'when without a name' do
      subject(:permission) { build_stubbed(:permission, name: nil) }

      it { expect(permission).not_to be_valid }
    end
  end
end
