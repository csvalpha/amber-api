require 'rails_helper'

RSpec.describe VacancyPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :update? do
    describe 'when vacancy is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:vacancy)) }
    end

    describe 'when vacancy is owned' do
      it { expect(policy).to permit(user, build_stubbed(:vacancy, author: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'vacancy.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:vacancy)) }
    end
  end

  describe '#create_with_group?' do
    it { expect(policy.new(nil, nil).create_with_group?(nil)).to be true }
  end

  describe '#replace_group?' do
    it { expect(policy.new(nil, nil).replace_group?(nil)).to be true }
  end
end
