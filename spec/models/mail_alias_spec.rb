require 'rails_helper'

RSpec.describe MailAlias, type: :model do
  describe '#valid' do
    context 'when without moderation type' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, moderation_type: nil) }

      it { expect(mail_alias).not_to be_valid }
    end

    context 'when with group' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, :with_group) }

      it { expect(mail_alias).to be_valid }
    end

    context 'when with user' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, :with_user) }

      it { expect(mail_alias).to be_valid }
    end

    context 'when with unknown mail domain' do
      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias,
                                 :with_group, email: 'blaat@example.org')
      end

      it { expect(mail_alias).not_to be_valid }
    end

    context 'when with duplicate email' do
      let(:other_mail_alias) { FactoryBot.create(:mail_alias, :with_group) }

      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias,
                                 :with_group, email: other_mail_alias.email)
      end

      it { expect(mail_alias).not_to be_valid }
    end

    context 'when without user and group' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, user: nil, group: nil) }

      it { expect(mail_alias).not_to be_valid }
    end

    context 'when with both user and group' do
      let(:user) { FactoryBot.build_stubbed(:user) }

      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, :with_group, user: user)
      end

      before { mail_alias.valid? }

      it { expect(mail_alias.errors[:base].first).to include 'one group OR one user' }
    end

    context 'when with a moderated alias' do
      context 'when without moderator' do
        subject(:mail_alias) do
          FactoryBot.build_stubbed(:mail_alias, :with_user, moderation_type: 'moderated')
        end

        before { mail_alias.valid? }

        it { expect(mail_alias.errors[:base].first).to include 'Must have a moderator' }
      end

      context 'when with moderator' do
        subject(:mail_alias) do
          FactoryBot.build_stubbed(:mail_alias, :with_user, :with_moderator,
                                   moderation_type: 'moderated')
        end

        it { expect(mail_alias).to be_valid }
      end
    end

    context 'when with a semi moderated alias' do
      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, :with_user, moderation_type: 'semi_moderated')
      end

      before { mail_alias.valid? }

      it { expect(mail_alias.errors[:base].first).to include 'Must have a moderator' }
    end
  end

  context '#mail_addresses' do
    context 'when with group' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, :with_group) }

      it do
        expect(mail_alias.mail_addresses).to match_array(mail_alias.group.users.map(&:email))
      end
    end

    context 'when with user' do
      subject(:mail_alias) { FactoryBot.build_stubbed(:mail_alias, :with_user) }

      it { expect(mail_alias.mail_addresses).to match_array([mail_alias.user.email]) }
    end
  end

  context '#downcase_email' do
    subject(:mail_alias) do
      FactoryBot.create(:mail_alias, :with_group, email: 'Test@csvalpha.nl')
    end

    it { expect(mail_alias.email).to eq 'test@csvalpha.nl' }
  end

  context '#moderators' do
    context 'when with open alias' do
      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, :with_group, moderation_type: 'open')
      end

      it { expect(mail_alias.mail_addresses).to be_empty }
    end

    context 'when with moderated alias' do
      let(:moderator_group) { FactoryBot.create(:group, users: [FactoryBot.create(:user)]) }

      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, :with_group,
                                 moderation_type: 'moderated', moderator_group: moderator_group)
      end

      it { expect(mail_alias.moderators.count).to be 1 }
    end
  end

  context '#domain' do
    let(:mail_alias) { FactoryBot.build(:mail_alias, email: 'test@csvalpha.nl') }

    it { expect(mail_alias.domain).to eq 'csvalpha.nl' }
  end

  context '#to_s' do
    context 'when with a user' do
      let(:user) do
        FactoryBot.build_stubbed(:user, first_name: 'Alpha', last_name_prefix: nil,
                                        last_name: 'Amber')
      end

      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, user: user, email: 'amber@csvalpha.nl')
      end

      it { expect(mail_alias.to_s).to eq('Alpha Amber <amber@csvalpha.nl>') }
    end

    context 'when with group' do
      let(:group) { FactoryBot.create(:group, name: 'ICT-commissie') }

      subject(:mail_alias) do
        FactoryBot.build_stubbed(:mail_alias, group: group, user: nil, email: 'ict@csvalpha.nl')
      end

      it { expect(mail_alias.to_s).to eq('ICT-commissie <ict@csvalpha.nl>') }
    end
  end

  context '#set_smtp' do
    let(:mail_alias) { FactoryBot.create(:mail_alias) }
    let(:mailgun_client) { Mailgun::Client.new }
    let(:mail) { ActionMailer::Base.deliveries.first }

    context '#enable_smtp' do
      before do
        ActionMailer::Base.deliveries = []
        allow(mail_alias).to receive(:mailgun_client) { mailgun_client }
        allow(mailgun_client).to receive(:post).and_return(true)

        perform_enqueued_jobs do
          VCR.use_cassette('mailgun_enable_smtp') { mail_alias.__send__(:enable_smtp) }
        end
      end

      it { expect(mailgun_client).to have_received(:post) }
      it { expect(mail.to).to eq [mail_alias.email] }
      it { expect(mail.subject).to eq "SMTP account voor #{mail_alias.email} aangemaakt" }
    end

    context '#disable_smtp' do
      before do
        ActionMailer::Base.deliveries = []
        allow(mail_alias).to receive(:mailgun_client) { mailgun_client }
        allow(mailgun_client).to receive(:delete).and_return(true)

        perform_enqueued_jobs do
          VCR.use_cassette('mailgun_disable_smtp') { mail_alias.__send__(:disable_smtp) }
        end
      end

      it { expect(mailgun_client).to have_received(:delete) }
      it { expect(mail.to).to eq [mail_alias.email] }
      it { expect(mail.subject).to eq "SMTP account voor #{mail_alias.email} opgeheven" }
    end
  end
end
