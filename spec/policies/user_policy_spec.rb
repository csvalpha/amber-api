require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build_stubbed(:user) }

  permissions :index? do
    describe 'when authenticated' do
      it { expect(policy).to permit(user, FactoryBot.create(:user)) }
    end
  end

  permissions :show? do
    describe 'when authenticated' do
      it { expect(policy).to permit(user, FactoryBot.create(:user)) }
    end

    describe 'when with tomato application' do
      let(:application) { Doorkeeper::Application.create(name: 'Tomato', scopes: 'tomato') }

      it do
        expect(policy).to permit(application,
                                 FactoryBot.create(:user, allow_tomato_sharing: true))
      end

      it do
        expect(policy).not_to permit(application,
                                     FactoryBot.create(:user, allow_tomato_sharing: false))
      end
    end
  end

  permissions :update? do
    let(:record_permission) { 'user.update' }

    describe 'when user is not itself' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:user)) }
    end

    describe 'when user is itself' do
      it { expect(policy).to permit(user, user) }
    end

    describe 'when with permission' do
      let(:permitted_user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(permitted_user, user) }
    end

    describe 'when user is archived' do
      let(:user) { FactoryBot.build_stubbed(:user, archived_at: Date.yesterday) }

      it { expect(policy).not_to permit(user, user) }

      describe 'when with permission' do
        let(:permitted_user) do
          FactoryBot.create(:user, user_permission_list: [record_permission])
        end

        it { expect(policy).to permit(permitted_user, user) }
      end
    end
  end

  describe '#create_with_user_permissions?' do
    it { expect(policy.new(nil, nil).create_with_user_permissions?(nil)).to be true }
  end

  describe '#replace_user_permissions?' do
    it { expect(policy.new(nil, nil).replace_user_permissions?(nil)).to be true }
  end
end
