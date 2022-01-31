require 'rails_helper'

RSpec.describe ActivityPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when activity is not owned' do
      it { expect(policy).not_to permit(user, build(:activity)) }
    end

    describe 'when activity is owned' do
      it { expect(policy).to permit(user, build(:activity, author: user)) }
    end
  end

  describe '#create_with_form?' do
    it { expect(policy.new(nil, nil).create_with_form?(nil)).to be true }
  end

  describe '#replace_form?' do
    it { expect(policy.new(nil, nil).replace_form?(nil)).to be true }
  end

  describe '#create_with_group?' do
    it { expect(policy.new(nil, nil).create_with_group?(nil)).to be true }
  end

  describe '#replace_group?' do
    it { expect(policy.new(nil, nil).replace_group?(nil)).to be true }
  end
end
