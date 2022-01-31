require 'rails_helper'

RSpec.describe PollPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when poll is not owned' do
      it { expect(policy).not_to permit(user, build(:poll)) }
    end

    describe 'when poll is owned' do
      it { expect(policy).to permit(user, build(:poll, author: user)) }
    end
  end

  describe '#create_with_form?' do
    it { expect(policy.new(nil, nil).create_with_form?(nil)).to be true }
  end

  describe '#replace_form?' do
    it { expect(policy.new(nil, nil).replace_form?(nil)).to be true }
  end
end
