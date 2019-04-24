require 'rails_helper'

RSpec.describe Forum::ThreadPolicy, type: :policy do
  let(:user) { FactoryBot.build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  context '#create_with_category?' do
    it { expect(policy.create_with_category?(nil)).to be true }
  end

  context '#replace_category?' do
    it { expect(policy.replace_category?(nil)).to be true }
  end

  context '#create_with_author?' do
    it { expect(policy.create_with_author?(nil)).to be true }
  end

  context '#replace_author?' do
    it { expect(policy.replace_author?(nil)).to be true }
  end
end
