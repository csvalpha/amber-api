shared_examples 'a model with group owners' do
  let(:model_name) { described_class.to_s.underscore.split('/').last }

  context 'when the user is not owner, but it belongs to a group' do
    let(:user) { create(:user) }
    let(:group) { create(:group, users: [user]) }

    subject(:model) { build_stubbed(model_name, group: group) }

    it { expect(model.owners).to include user }
  end

  context 'when it does not belong to a group, but the user is owner' do
    let(:user) { create(:user) }

    subject(:model) { build_stubbed(model_name, author: user, group: nil) }

    it { expect(model.owners).to include user }
  end

  context 'when it belongs to a group, but the user is old member of the group' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      create(:membership, group: group, user: user, end_date: 1.day.ago)
    end

    subject(:model) { build_stubbed(model_name, group: group) }

    it { expect(model.owners).not_to include user }
  end

  context 'when the user is owner and it belongs to a group the user is old member of' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      create(:membership, group: group, user: user, end_date: 1.day.ago)
    end

    subject(:model) { build_stubbed(model_name, author: user, group: group) }

    it { expect(model.owners).to include user }
  end
end
