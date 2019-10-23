require 'rails_helper'

RSpec.describe MailAliasPolicy, type: :policy do
  let(:user) { FactoryBot.build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  describe '#create_with_group?' do
    it { expect(policy.create_with_group?(nil)).to be true }
  end

  describe '#replace_group?' do
    it { expect(policy.replace_group?(nil)).to be true }
  end

  describe '#create_with_user?' do
    it { expect(policy.create_with_user?(nil)).to be true }
  end

  describe '#replace_user?' do
    it { expect(policy.replace_user?(nil)).to be true }
  end
end
