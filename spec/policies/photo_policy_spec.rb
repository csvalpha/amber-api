require 'rails_helper'

RSpec.describe PhotoPolicy, type: :policy do
  let(:record_permission) { 'photo.read' }
  let(:user) { create(:user, user_permission_list: [record_permission]) }
  let(:record) { create(:photo) }

  subject(:policy) { described_class.new(user, record) }

  describe '#get_related_resources?' do
    it { expect(policy.get_related_resources?).to be true }
  end
end
