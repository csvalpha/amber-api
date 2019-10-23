require 'rails_helper'

RSpec.describe PhotoCommentPolicy, type: :policy do
  subject(:policy) { described_class.new(nil, nil) }

  let(:user) { FactoryBot.build(:user) }

  describe '#create_with_photo?' do
    it { expect(policy.create_with_photo?(nil)).to be true }
  end

  describe '#replace_photo?' do
    it { expect(policy.replace_photo?(nil)).to be true }
  end
end
