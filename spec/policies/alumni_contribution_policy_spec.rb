require 'rails_helper'

RSpec.describe AlumniContributionPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:alumni_contribution) }

  permissions :index?, :show? do
    describe 'when record is not owned and without permission' do
      it { expect(policy).not_to permit(user, record) }
    end

    describe 'when record is owned' do
      let(:record) { build_stubbed(:alumni_contribution, user:) }

      it { expect(policy).to permit(user, record) }
    end

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: ['alumni_contribution.read']) }

      it { expect(policy).to permit(user, record) }
    end
  end

  permissions :create? do
    describe 'when without permission' do
      it { expect(policy).not_to permit(user, record) }
    end

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: ['alumni_contribution.create']) }

      it { expect(policy).to permit(user, record) }
    end
  end

  permissions :update?, :destroy? do
    describe 'when record is not owned and without permission' do
      it { expect(policy).not_to permit(user, record) }
    end

    describe 'when record is owned' do
      let(:record) { build_stubbed(:alumni_contribution, user:) }

      it { expect(policy).to permit(user, record) }
    end

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: ['alumni_contribution.update']) }

      it { expect(policy).to permit(user, record) }
    end
  end
end
