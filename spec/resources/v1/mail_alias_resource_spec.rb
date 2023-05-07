require 'rails_helper'

RSpec.describe V1::MailAliasResource, type: :resource do
  let(:context) { { user: } }
  let(:record) { create(:mail_alias) }
  let(:resource) { described_class.new(record, context) }

  describe '#fetchable_fields' do
    let(:read_fields) do
      %i[email moderation_type description smtp_enabled
         created_at group id moderator_group updated_at user]
    end

    context 'when with read permission' do
      let(:user) { create(:user, user_permission_list: ['mail_alias.read']) }

      it { expect(resource.fetchable_fields).to match_array(read_fields) }
    end

    context 'when with update permission' do
      let(:user) { create(:user, user_permission_list: ['mail_alias.update']) }

      it { expect(resource.fetchable_fields).to match_array(read_fields + [:last_received_at]) }
    end
  end
end
