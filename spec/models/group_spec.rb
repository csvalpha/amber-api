require 'rails_helper'

RSpec.describe Group, type: :model do
  subject(:group) { FactoryBot.build_stubbed(:group) }

  describe '#valid?' do
    it { expect(group).to be_valid }

    context 'when without a name' do
      subject(:group) { FactoryBot.build_stubbed(:group, name: nil) }

      it { expect(group).not_to be_valid }
    end

    context 'when without administrative' do
      subject(:group) { FactoryBot.build_stubbed(:group, administrative: nil) }

      it { expect(group).not_to be_valid }
    end

    context 'when without a kind' do
      subject(:group) { FactoryBot.build_stubbed(:group, kind: nil) }

      it { expect(group).not_to be_valid }
    end

    context 'when with an invalid kind' do
      subject(:group) do
        FactoryBot.build_stubbed(:group, kind: 'i_am_sure_this_this_is_an_invalid_kind')
      end

      it { expect(group).not_to be_valid }
    end
  end

  describe '.active_users' do
    subject(:group) { FactoryBot.create(:group) }

    let(:user) { FactoryBot.create(:user) }

    context 'when with active membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user)
      end

      it { expect(group.active_users).to contain_exactly(user) }
    end

    context 'when with expired membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(group.active_users).to be_empty }
    end

    context 'when with future membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, start_date: Time.zone.now + 1.day)
      end

      it { expect(group.active_users).to be_empty }
    end

    context 'when with expired and current membership' do
      let(:group2) { FactoryBot.create(:group) }

      before do
        FactoryBot.create(:membership, group: group, user: user)
        FactoryBot.create(:membership, group: group2, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(group.active_users).to contain_exactly(user) }
    end
  end

  describe '.active' do
    subject(:group) { FactoryBot.create(:group) }

    let(:user) { FactoryBot.create(:user) }

    context 'when without active membership' do
      it { expect(described_class.active.length).to eq 0 }
    end

    context 'when with active membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user)
      end

      it { expect(described_class.active.length).to eq 1 }
    end

    context 'when with expired membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(described_class.active.length).to eq 0 }
    end

    context 'when with future membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, start_date: Time.zone.now + 1.day)
      end

      it { expect(described_class.active.length).to eq 0 }
    end
  end

  describe '.active_groups_for_user' do
    subject(:group) { FactoryBot.create(:group) }

    let(:user) { FactoryBot.create(:user) }

    context 'when with active membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user)
      end

      it { expect(described_class.active_groups_for_user(user).length).to eq 1 }
    end

    context 'when with expired membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(described_class.active_groups_for_user(user).length).to eq 0 }
    end

    context 'when with future membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, start_date: Time.zone.now + 1.day)
      end

      it { expect(described_class.active_groups_for_user(user).length).to eq 0 }
    end

    context 'when with expired and current membership' do
      let(:group2) { FactoryBot.create(:group) }

      before do
        FactoryBot.create(:membership, group: group, user: user)
        FactoryBot.create(:membership, group: group2, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(described_class.active_groups_for_user(user).length).to eq 1 }
      it { expect(described_class.active_groups_for_user(user).first).to eq group }
    end
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :avatar
  end

  describe '#destroy' do
    it_behaves_like 'a model with dependent destroy relationship', :membership
    it_behaves_like 'a model with dependent destroy relationship', :groups_permissions
  end
end
