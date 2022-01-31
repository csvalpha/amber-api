require 'rails_helper'

RSpec.describe Forum::ThreadPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  describe '#create_with_category?' do
    it { expect(policy.create_with_category?(nil)).to be true }
  end

  describe '#replace_category?' do
    it { expect(policy.replace_category?(nil)).to be true }
  end

  describe '#create_with_author?' do
    it { expect(policy.create_with_author?(nil)).to be true }
  end

  describe '#replace_author?' do
    it { expect(policy.replace_author?(nil)).to be true }
  end
end
