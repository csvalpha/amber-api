require 'rails_helper'

RSpec.describe PhotoTagPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when photo tag is not owned or tagged' do
      it { expect(policy).not_to permit(user, build(:photo_tag)) }
    end

    describe 'when photo tag is owned' do
      it { expect(policy).to permit(user, build(:photo_tag, author: user)) }
    end

    describe 'when photo tag is tagged' do
      it { expect(policy).to permit(user, build(:photo_tag, tagged_user: user)) }
    end
  end

  describe '#create_with_photo?' do
    it { expect(policy.new(nil, nil).create_with_photo?(nil)).to be true }
  end

  describe '#replace_photo?' do
    it { expect(policy.new(nil, nil).replace_photo?(nil)).to be true }
  end

  describe '#create_with_tagged_user?' do
    it { expect(policy.new(nil, nil).create_with_tagged_user?(nil)).to be true }
  end

  describe '#replace_tagged_user?' do
    it { expect(policy.new(nil, nil).replace_tagged_user?(nil)).to be true }
  end
end
