require 'rails_helper'

RSpec.describe StoredMail, type: :model do
  describe '#valid' do
    subject(:stored_mail) { FactoryBot.build_stubbed(:stored_mail) }

    describe '#valid' do
      it { expect(stored_mail).to be_valid }

      context 'when without a received at' do
        subject(:stored_mail) { FactoryBot.build_stubbed(:stored_mail, received_at: nil) }

        it { expect(stored_mail).not_to be_valid }
      end

      context 'when without a sender' do
        subject(:stored_mail) { FactoryBot.build_stubbed(:stored_mail, sender: nil) }

        it { expect(stored_mail).not_to be_valid }
      end

      context 'when without a mail alias' do
        subject(:stored_mail) { FactoryBot.build_stubbed(:stored_mail, mail_alias: nil) }

        it { expect(stored_mail).not_to be_valid }
      end
    end
  end

  describe '#stored_mails_moderated_by_user' do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group, users: [user]) }
    let(:moderated_mail_alias) do
      FactoryBot.create(:mail_alias, :with_group,
                        moderation_type: :moderated, moderator_group: group)
    end

    before do
      FactoryBot.create(:stored_mail, mail_alias: moderated_mail_alias)
      FactoryBot.create(:stored_mail, mail_alias: moderated_mail_alias)
      FactoryBot.create(:stored_mail)
    end

    it { expect(described_class.stored_mails_moderated_by_user(user).count).to eq 2 }

    it do
      expect(described_class.count - described_class.stored_mails_moderated_by_user(user).count)
        .to eq 1
    end
  end
end
