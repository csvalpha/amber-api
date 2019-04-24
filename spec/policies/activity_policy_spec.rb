require 'rails_helper'

RSpec.describe ActivityPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build(:user) }

  permissions :update? do
    describe 'when activity is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build(:activity)) }
    end

    describe 'when activity is owned' do
      it { expect(policy).to permit(user, FactoryBot.build(:activity, author: user)) }
    end
  end

  context '#create_with_form?' do
    it { expect(policy.new(nil, nil).create_with_form?(nil)).to be true }
  end

  context '#replace_form?' do
    it { expect(policy.new(nil, nil).replace_form?(nil)).to be true }
  end

  context '#create_with_group?' do
    it { expect(policy.new(nil, nil).create_with_group?(nil)).to be true }
  end

  context '#replace_group?' do
    it { expect(policy.new(nil, nil).replace_group?(nil)).to be true }
  end
end
