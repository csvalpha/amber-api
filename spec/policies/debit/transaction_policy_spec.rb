require 'rails_helper'

RSpec.describe Debit::TransactionPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  describe '#create_with_user?' do
    it { expect(policy.create_with_user?(nil)).to be true }
  end

  describe '#replace_user?' do
    it { expect(policy.replace_user?(nil)).to be true }
  end

  describe '#create_with_collection?' do
    it { expect(policy.create_with_collection?(nil)).to be true }
  end

  describe '#replace_collection?' do
    it { expect(policy.replace_collection?(nil)).to be true }
  end
end
