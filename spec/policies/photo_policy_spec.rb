require 'rails_helper'

RSpec.describe PhotoPolicy, type: :policy do
  subject(:policy) { described_class.new(nil, nil) }

  context '#get_related_resources?' do
    it { expect(policy.get_related_resources?).to be true }
  end
end
