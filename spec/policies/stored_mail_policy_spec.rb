require 'rails_helper'

RSpec.describe StoredMailPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:moderator_group) { create(:group, users: [user]) }
  let(:mail_alias) do
    create(:mail_alias, :with_group,
           moderation_type: :moderated, moderator_group:)
  end
  let(:stored_mail) { build_stubbed(:stored_mail, mail_alias:) }

  action_permission_map =
    {
      show?: 'stored_mail.read',
      destroy?: 'stored_mail.destroy',
      accept?: 'stored_mail.destroy',
      reject?: 'stored_mail.destroy'
    }

  action_permission_map.each do |action, permission|
    context "##{action}" do
      context 'when user is moderator' do
        subject(:policy) { described_class.new(user, stored_mail) }

        it { expect(policy.public_send(action)).to be true }
      end

      context 'when user is not moderator' do
        subject(:policy) { described_class.new(user, build_stubbed(:stored_mail)) }

        it { expect(policy.public_send(action)).to be false }
      end

      context 'with permission' do
        context 'when user is not moderator' do
          let(:user) { create(:user, user_permission_list: [permission]) }

          subject(:policy) { described_class.new(user, build_stubbed(:stored_mail)) }

          it { expect(policy.public_send(action)).to be true }
        end
      end
    end
  end
end
