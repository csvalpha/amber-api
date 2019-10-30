require 'rails_helper'

RSpec.describe ArticleCommentPolicy, type: :policy do
  subject(:policy) { described_class.new(nil, nil) }

  let(:user) { FactoryBot.build(:user) }

  describe '#create_with_article?' do
    it { expect(policy.create_with_article?(nil)).to be true }
  end

  describe '#replace_article?' do
    it { expect(policy.replace_article?(nil)).to be true }
  end
end
