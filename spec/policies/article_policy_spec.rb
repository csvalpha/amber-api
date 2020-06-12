require 'rails_helper'

RSpec.describe ArticlePolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build(:user) }

  permissions :update? do
    describe 'when article is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:article)) }
    end

    describe 'when article is owned' do
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:article, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'article.update' }
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:article)) }
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:article, :pinned))}
    end

    describe 'when with no permission' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:article, :pinned))}
    end
  end
end
