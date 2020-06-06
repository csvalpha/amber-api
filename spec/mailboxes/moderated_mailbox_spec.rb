require 'rails_helper'

RSpec.describe ModeratedMailbox, type: :mailbox do
  subject do
    receive_inbound_email_from_mail(
        from: 'someone@example.com',
        'Delivered-To': mail_alias.email,
        subject: 'Sample Subject',
        body: "I'm a sample body"
    )
  end

  describe 'Moderated mail is converted into stored mail' do
    context 'When for moderated address' do
      let(:mail_alias) { FactoryBot.create(:mail_alias, :with_moderator)}

      before { subject }

      it { expect(StoredMail.first.mail_alias).to eq mail_alias}
      it { expect(StoredMail.first.inbound_email).to eq subject}
    end

    context 'When for non-moderated address' do
      let(:mail_alias) { FactoryBot.create(:mail_alias)}

      it { expect { subject }.not_to change(StoredMail, :count) }
    end

    context 'When for non-existing address' do
      let(:mail_alias) { FactoryBot.build(:mail_alias)}

      it { expect { subject }.not_to change(StoredMail, :count) }
    end

  end
end
