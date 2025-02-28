require 'rails_helper'

RSpec.describe StoredMail do
  describe '#valid' do
    subject(:stored_mail) { build_stubbed(:stored_mail) }

    describe '#valid' do
      it { expect(stored_mail).to be_valid }

      context 'when without a inbound email' do
        subject(:stored_mail) { build_stubbed(:stored_mail, inbound_email: nil) }

        it { expect(stored_mail).not_to be_valid }
      end

      context 'when without a mail alias' do
        subject(:stored_mail) { build_stubbed(:stored_mail, mail_alias: nil) }

        it { expect(stored_mail).not_to be_valid }
      end
    end
  end

  describe '#stored_mails_moderated_by_user' do
    let(:user) { create(:user) }
    let(:group) { create(:group, users: [user]) }
    let(:moderated_mail_alias) do
      create(:mail_alias, :with_group,
             moderation_type: :moderated, moderator_group: group)
    end

    before do
      create(:stored_mail, mail_alias: moderated_mail_alias)
      create(:stored_mail, mail_alias: moderated_mail_alias)
      create(:stored_mail)
    end

    it { expect(described_class.stored_mails_moderated_by_user(user).count).to eq 2 }

    it do
      expect(described_class.count - described_class.stored_mails_moderated_by_user(user).count)
        .to eq 1
    end
  end
end
