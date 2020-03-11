require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build_stubbed(:user) }

  describe '#valid?' do
    it { expect(user).to be_valid }

    context 'when without a username' do
      subject(:user) { FactoryBot.build_stubbed(:user, username: nil) }

      it { expect(user).to be_valid }
    end

    context 'when with a username containing spaces' do
      subject(:user) { FactoryBot.build_stubbed(:user, username: 'contains a space') }

      it { expect(user).not_to be_valid }
    end

    context 'when without an email' do
      subject(:user) { FactoryBot.build_stubbed(:user, email: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without a first name' do
      subject(:user) { FactoryBot.build_stubbed(:user, first_name: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without a last name' do
      subject(:user) { FactoryBot.build_stubbed(:user, last_name: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without an address' do
      subject(:user) { FactoryBot.build_stubbed(:user, address: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without a postcode' do
      subject(:user) { FactoryBot.build_stubbed(:user, postcode: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without a city' do
      subject(:user) { FactoryBot.build_stubbed(:user, city: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without a phone_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, phone_number: nil) }

      it { expect(user).to be_valid }
    end

    context 'when with a blank phone_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, phone_number: '') }

      it { expect(user).to be_valid }
    end

    context 'when with an invalid phone_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, phone_number: '+31612345678901') }

      it { expect(user).not_to be_valid }
    end

    context 'when without an login_enabled state' do
      subject(:user) { FactoryBot.build_stubbed(:user, login_enabled: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without an vegetarian state' do
      subject(:user) { FactoryBot.build_stubbed(:user, vegetarian: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when without an emergency_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, emergency_number: nil) }

      it { expect(user).to be_valid }
    end

    context 'when with an invalid emergency_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, emergency_number: '+3161234567890') }

      it { expect(user).not_to be_valid }
    end

    context 'when with a blank emergency_number' do
      subject(:user) { FactoryBot.build_stubbed(:user, emergency_number: '') }

      it { expect(user).to be_valid }
    end

    context 'when without an emergency_contact' do
      subject(:user) { FactoryBot.build_stubbed(:user, emergency_contact: nil) }

      it { expect(user).to be_valid }
    end

    context 'when re-null picture_publication_preference' do
      subject(:user) { FactoryBot.create(:user) }

      it { expect(user.update(picture_publication_preference: nil)).to eq false }
    end

    context 'when with an invalid picture_publication_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, picture_publication_preference: 'wrong!') }

      it { expect(user).not_to be_valid }
    end

    context 'when re-null ifes_data_sharing_preference' do
      subject(:user) { FactoryBot.create(:user) }

      it { expect(user.update(ifes_data_sharing_preference: nil)).to eq false }
    end

    context 'when re-null valid info_in_almanak' do
      subject(:user) { FactoryBot.create(:user) }

      it { expect(user.update(ifes_data_sharing_preference: nil)).to eq false }
    end

    context 'when re-null user_details_sharing_preference' do
      subject(:user) { FactoryBot.create(:user) }

      it { expect(user.update(user_details_sharing_preference: nil)).to eq false }
    end

    context 'when with an invalid user_details_sharing_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, user_details_sharing_preference: 'wrong!') }

      it { expect(user).not_to be_valid }
    end

    context 'when without almanak_subscription_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, almanak_subscription_preference: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when with an invalid almanak_subscription_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, almanak_subscription_preference: 'wrong!') }

      it { expect(user).not_to be_valid }
    end

    context 'when without digtus_subscription_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, digtus_subscription_preference: nil) }

      it { expect(user).not_to be_valid }
    end

    context 'when with an valid digtus_subscription_preference' do
      subject(:user) { FactoryBot.build_stubbed(:user, digtus_subscription_preference: 'wrong!') }

      it { expect(user).not_to be_valid }
    end

    context 'when activated with nil password' do
      subject(:user) do
        FactoryBot.build_stubbed(:user, password: nil, activated_at: Time.zone.now)
      end

      it { expect(user).not_to be_valid }
    end

    context 'when activated with too short password' do
      subject(:user) do
        FactoryBot.build_stubbed(:user, password: '<12char', activated_at: Time.zone.now)
      end

      it { expect(user).not_to be_valid }
    end

    context 'when activated with empty password' do
      subject(:user) { FactoryBot.build_stubbed(:user, password: '', activated_at: Time.zone.now) }

      it { expect(user).not_to be_valid }
    end

    context 'when activated with password' do
      subject(:user) { FactoryBot.build_stubbed(:user, activated_at: Time.zone.now) }

      it { expect(user).to be_valid }
    end

    context 'when having duplicate fields' do
      let(:user) { FactoryBot.create(:user) }

      context 'username' do
        subject(:duplicate_user) { FactoryBot.build_stubbed(:user, username: user.username) }

        it { expect(duplicate_user).not_to be_valid }
      end

      context 'email' do
        subject(:duplicate_user) { FactoryBot.build_stubbed(:user, email: user.email) }

        it { expect(duplicate_user).not_to be_valid }
      end
    end

    context 'when allow_tomato_sharing is changed' do
      context 'from nil to false' do
        let(:user) { FactoryBot.create(:user, allow_tomato_sharing: nil) }

        before { user.allow_tomato_sharing = false }

        it { expect(user).to be_valid }
      end

      context 'from true to false' do
        let(:user) { FactoryBot.create(:user, allow_tomato_sharing: true) }

        before { user.allow_tomato_sharing = false }

        it { expect(user).not_to be_valid }
      end
    end
  end

  describe '.active_groups' do
    subject(:user) { FactoryBot.create(:user) }

    let(:group) { FactoryBot.create(:group) }

    context 'when with active membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user)
      end

      it { expect(user.active_groups).to contain_exactly(group) }
    end

    context 'when with expired membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(user.active_groups).to be_empty }
    end

    context 'when with future membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, start_date: Time.zone.now + 1.day)
      end

      it { expect(user.active_groups).to be_empty }
    end

    context 'when with expired and current membership' do
      let(:group2) { FactoryBot.create(:group) }

      before do
        FactoryBot.create(:membership, group: group, user: user)
        FactoryBot.create(:membership, group: group2, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(user.active_groups).to contain_exactly(group) }
    end
  end

  describe '.group_mail_aliases' do
    subject(:user) { FactoryBot.create(:user) }

    let(:mail_alias) { FactoryBot.create(:mail_alias, :with_group) }
    let(:group) { mail_alias.group }

    context 'when with active membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user)
      end

      it { expect(user.group_mail_aliases).to contain_exactly(mail_alias) }
    end

    context 'when with expired membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, end_date: Time.zone.now - 1.day)
      end

      it { expect(user.group_mail_aliases).to be_empty }
    end

    context 'when with future membership' do
      before do
        FactoryBot.create(:membership, group: group, user: user, start_date: Time.zone.now + 1.day)
      end

      it { expect(user.group_mail_aliases).to be_empty }
    end
  end

  describe '.activated' do
    it do
      expect { FactoryBot.create(:user, activated_at: Time.zone.now) }.to(
        change { described_class.activated.count }.by(1)
      )
    end
  end

  describe '.contactsync_users' do
    it do
      expect { FactoryBot.create(:user, webdav_secret_key: SecureRandom.hex(32)) }.to(
        change { described_class.contactsync_users.count }.by(1)
      )
    end
  end

  describe '.login_enabled' do
    it do
      expect { FactoryBot.create(:user, login_enabled: true) }.to(
        change { described_class.login_enabled.count }.by(1)
      )
    end
  end

  describe '.tomato_users' do
    it do
      expect { FactoryBot.create(:user, allow_tomato_sharing: true) }.to(
        change { described_class.tomato_users.count }.by(1)
      )
    end
  end

  describe '.birthday' do
    before { FactoryBot.create(:user, birthday: Time.zone.local(1992, 10, 25)) }

    it { expect(described_class.birthday(10, 24).count).to eq(0) }
    it { expect(described_class.birthday(10, 25).count).to eq(1) }
    it { expect(described_class.birthday(10, 26).count).to eq(0) }
  end

  describe '.sidekiq_access' do
    it do
      expect { FactoryBot.create(:user, sidekiq_access: true) }.to(
        change { described_class.sidekiq_access.count }.by(1)
      )
    end
  end

  describe '.upcoming_birthdays' do
    context 'when with normal birthdays' do
      before do
        FactoryBot.create(:user, birthday: 1.day.ago)
        FactoryBot.create(:user, birthday: Time.current)
        FactoryBot.create(:user, birthday: 1.day.from_now)
      end

      it { expect(described_class.upcoming_birthdays(0).count).to eq(1) }
      it { expect(described_class.upcoming_birthdays(1).count).to eq(2) }
    end

    context 'when with birthday 29 February in leap year' do
      before do
        Timecop.freeze(Date.new(2016, 2, 28))
        FactoryBot.create(:user, birthday: Date.new(1992, 2, 28))
        FactoryBot.create(:user, birthday: Date.new(1992, 2, 29))
      end

      after do
        Timecop.return
      end

      it { expect(described_class.upcoming_birthdays(0).count).to eq(1) }
      it { expect(described_class.upcoming_birthdays(1).count).to eq(2) }
      it { expect(described_class.upcoming_birthdays(2).count).to eq(2) }
    end

    context 'when with birthday 29 February in non-leap year' do
      before do
        Timecop.freeze(Date.new(2017, 2, 28))
        FactoryBot.create(:user, birthday: Date.new(1992, 2, 28))
        FactoryBot.create(:user, birthday: Date.new(1992, 2, 29))
      end

      after do
        Timecop.return
      end

      it { expect(described_class.upcoming_birthdays(0).count).to eq(2) }
      it { expect(described_class.upcoming_birthdays(1).count).to eq(2) }
      it { expect(described_class.upcoming_birthdays(2).count).to eq(2) }
    end
  end

  describe '.archived' do
    let(:user) {}
    let(:users) { FactoryBot.create_list(:user, 2) }
    let(:archived_user) { FactoryBot.create(:user) }

    before do
      users
      archived_user.archive!
    end

    context 'when archived true' do
      it { expect(described_class.archived(true).size).to eq 1 }
      it { expect(described_class.archived(true)).to include archived_user }
    end

    context 'when archived true implicit' do
      it { expect(described_class.archived.size).to eq 1 }
      it { expect(described_class.archived).to include archived_user }
    end

    context 'when archived false' do
      it { expect(described_class.archived(false).size).to eq 2 }
      it { expect(described_class.archived(false)).to include users.first }
    end
  end

  describe '#destroy' do
    subject(:user) { FactoryBot.create(:user) }

    it { expect(user.destroy).to be false }
  end

  describe 'self.to_csv' do
    subject(:user) do
      FactoryBot.create(:user, first_name: 'Erik', last_name_prefix: 'de', last_name: 'Vries')
    end

    before { user }

    it { expect(described_class.to_csv([:full_name])).to eq "full_name\nErik de Vries\n" }
  end

  describe '#save' do
    it_behaves_like 'a model accepting a base 64 image as', :avatar

    context 'when updating an existing user' do
      subject(:user) { FactoryBot.create(:user) }

      it 'requires no password' do
        expect(user.update(username: Faker::Internet.user_name)).to be true
      end
    end

    context 'when disabling a user' do
      let(:user) { FactoryBot.create(:user) }

      before do
        Doorkeeper::AccessToken.create!(resource_owner_id: user.id)
      end

      it do
        expect { user.update(login_enabled: false) }.to(
          change { valid_access_tokens_for(user.id).count }.by(-1)
        )
      end
    end
  end

  describe '#create' do
    let(:user) { FactoryBot.build(:user) }

    it { expect { user.save && user.reload }.to(change(user, :ical_secret_key)) }
  end

  describe '#generate_username' do
    context 'with blank last name prefix' do
      subject(:user) do
        FactoryBot.create(:user, first_name: 'First', last_name_prefix: '',
                                 last_name: 'Last', username: nil)
      end

      it { expect(user.username).to eq 'first.last' }
    end

    context 'without last name prefix' do
      subject(:user) do
        FactoryBot.create(:user, first_name: 'First', last_name_prefix: nil,
                                 last_name: 'Last', username: nil)
      end

      it { expect(user.username).to eq 'first.last' }
    end

    context 'with last name prefix' do
      subject(:user) do
        FactoryBot.create(:user, first_name: 'First', last_name_prefix: 'Prefix',
                                 last_name: 'Last', username: nil)
      end

      it { expect(user.username).to eq 'first.prefixlast' }
    end

    context 'with spaces in name' do
      subject(:user) do
        FactoryBot.create(:user, first_name: 'First First2',
                                 last_name_prefix: 'Prefix Prefix2',
                                 last_name: 'Last Last2', username: nil)
      end

      it { expect(user.username).to eq 'firstfirst2.prefixprefix2lastlast2' }
    end

    context 'with special character in name' do
      subject(:user) do
        FactoryBot.create(:user, first_name: 'äëï',
                                 last_name_prefix: '', last_name: 'õ', username: nil)
      end

      it { expect(user.username).to eq 'aei.o' }
    end

    context 'with already existing username' do
      before do
        FactoryBot.create(:user, username: 'first.prefixlast')
        FactoryBot.create(:user, username: 'first.prefixlast1')
      end

      subject(:user) do
        FactoryBot.create(:user, first_name: 'First', last_name_prefix: 'Prefix',
                                 last_name: 'Last', username: nil)
      end

      it { expect(user.username).to eq 'first.prefixlast2' }
    end
  end

  describe '#full_name' do
    describe 'with blank last name prefix' do
      subject(:user) do
        described_class.new(first_name: 'First', last_name_prefix: '', last_name: 'Last')
      end

      it { expect(user.full_name).to eq 'First Last' }
    end

    describe 'without last name prefix' do
      subject(:user) { described_class.new(first_name: 'First', last_name: 'Last') }

      it { expect(user.full_name).to eq 'First Last' }
    end

    describe 'with last name prefix' do
      subject(:user) do
        described_class.new(first_name: 'First', last_name_prefix: 'Prefix', last_name: 'Last')
      end

      it { expect(user.full_name).to eq 'First Prefix Last' }
    end
  end

  describe '#permission?' do
    describe '#user_permissions' do
      subject(:user) { FactoryBot.create(:user, user_permission_list: ['user.read']) }

      it { expect(user.permission?(:read, user)).to be true }
      it { expect(user.permission?(:update, user)).to be false }

      describe 'when hitting cache on same class' do
        before { user.permission?(:read, user) }

        it { expect(user.permission?(:read, user)).to be true }
        it { expect(user.permission?(:update, user)).to be false }
      end
    end

    describe '#group_permissions' do
      context 'when in group with active membership' do
        subject(:user) { FactoryBot.create(:user) }

        before { FactoryBot.create(:group, users: [user], permission_list: ['user.read']) }

        it { expect(user.permission?(:read, user)).to be true }
        it { expect(user.permission?(:update, user)).to be false }

        describe 'when hitting cache on same class' do
          before { user.permission?(:read, user) }

          it { expect(user.permission?(:read, user)).to be true }
          it { expect(user.permission?(:update, user)).to be false }
        end
      end

      context 'when in group with expired membership' do
        subject(:user) { FactoryBot.create(:user) }

        let(:group) do
          FactoryBot.create(:group, permission_list: ['user.destroy'])
        end

        before do
          FactoryBot.create(:group, users: [user], permission_list: ['user.read'])
          FactoryBot.create(:membership, user: user, group:
            group, end_date: Faker::Time.between(from: 1.month.ago, to: Date.yesterday))
        end

        it { expect(user.permission?(:read, user)).to be true }
        it { expect(user.permission?(:update, user)).to be false }
        it { expect(user.permission?(:destroy, user)).to be false }
      end
    end
  end

  describe '#current_group_member?' do
    subject(:user) { FactoryBot.create(:user) }

    let(:in_group) { FactoryBot.create(:group, users: [user]) }
    let(:another_group) { FactoryBot.create(:group) }

    context 'when in group' do
      it { expect(user.current_group_member?(in_group)).to be true }
    end

    context 'when not in group' do
      it { expect(user.current_group_member?(another_group)).to be false }
    end

    context 'when in group with expired membership' do
      before do
        FactoryBot.create(:membership, group: another_group, user: user,
                                       end_date: Faker::Time.between(from: 1.month.ago,
                                                                     to: Date.yesterday))
      end

      it { expect(user.current_group_member?(another_group)).to be false }
    end
  end

  describe '#activate_account' do
    context 'when creating a user' do
      subject(:user) { FactoryBot.create(:user) }

      it 'is not activated' do
        expect(user.activated_at).to be nil
      end

      context 'when activating the user and updating password' do
        let(:password) { Faker::Internet.password(min_length: 12) }

        before do
          user.activate_account!
          user.update(password: password)
        end

        it 'can login with the new password' do
          expect(user.authenticate(password)).to be user
        end

        it 'is activated' do
          expect(user.activated_at).to be < Time.zone.now
        end
      end
    end
  end

  describe '#archive!' do
    context 'when archiving a user' do
      with_versioning do
        subject(:user) { FactoryBot.create(:user) }

        let(:nil_attributes) do
          %w[email username password_digest deleted_at last_name_prefix birthday
             address postcode city phone_number food_preferences iban iban_holder study
             start_study activated_at activation_token avatar activation_token_valid_till
             sidekiq_access vegetarian picture_publication_preference emergency_contact
             emergency_number ifes_data_sharing_preference info_in_almanak
             almanak_subscription_preference digtus_subscription_preference]
        end

        before { user.archive! && user.reload }

        it { expect(user.archive!).to be true }
        it { expect(user.full_name).to eq "Gearchiveerde gebruiker #{user.id}" }
        it { expect(user.archived_at).not_to be_nil }
        it { expect(user.login_enabled).to be false }
        it { expect(user.versions).to be_empty }
        it { expect { user.archive! }.not_to(change(user, :id)) }

        it do
          nil_attributes.each do |attribute|
            expect(user[attribute]).to be_nil
          end
        end
      end
    end
  end

  describe '.password_reset_url' do
    it { expect(described_class.password_reset_url).to include('forgot_password') }
  end

  describe 'has_paper_trail' do
    with_versioning do
      let(:user) { FactoryBot.create(:user) }

      # Currently we have a problem with paper trail
      # which causes two versions to be created on each change
      # This is caused by the fact that we call paper trail twice
      # (once in ApplicationRecord and once in User)
      it { expect(user.versions.size).to eq 2 }

      it do
        expect { user.update(first_name: 'change') }.to(change { user.versions.size }.from(2).to(4))
      end
    end
  end

  private

  def valid_access_tokens_for(resource_owner_id)
    Doorkeeper::AccessToken.where(resource_owner_id: resource_owner_id, revoked_at: nil)
  end
end
