require 'rails_helper'

RSpec.describe Webdav::Addressbook, type: :model do
  let(:users) do
    [
      FactoryBot.create(:user, :webdav_enabled),
      FactoryBot.create(:user),
      FactoryBot.create(:user, :webdav_enabled)
    ]
  end
  let(:group) { FactoryBot.create(:group, users: users) }

  subject(:addressbook) { described_class.new(group) }

  describe '#name' do
    it { expect(addressbook.name).to eq(group.name) }
  end

  describe '#path' do
    it { expect(addressbook.path).to eq(group.id) }
  end

  describe '#contacts' do
    it { expect(addressbook.contacts.size).to eq(2) }

    it {
      expect(addressbook.contacts.collect(&:uid)).to contain_exactly(users[0].id.to_s,
                                                                     users[2].id.to_s)
    }
  end

  describe '#ctag' do
    it { expect(addressbook.ctag).to eq(group.updated_at.to_i) }
  end

  describe '#find_contact' do
    it { expect(addressbook.find_contact(users[2].id.to_s)).not_to be_nil }
    it { expect(addressbook.find_contact(users[2].id.to_s).uid).to eq(users[2].id.to_s) }
    it { expect(addressbook.find_contact(users[1].id.to_s)).to be_nil }
    it { expect(addressbook.find_contact((users[2].id + 1).to_s)).to be_nil }
  end

  describe '#find_contacts' do
    let(:uid) { users[0].id.to_s }
    let(:href) { "/webdav/1/secret/contacts/books/leden/#{uid}" }

    it do
      expect(addressbook.find_contacts(href => uid))
        .to eq(href => addressbook.contacts.find { |c| c.uid == uid })
    end
  end

  describe '#create_contact' do
    let(:new_contact) { Webdav::Contact.new(FactoryBot.build_stubbed(:user)) }

    before { users }

    it do
      expect { addressbook.create_contact(new_contact) }
        .not_to(change { addressbook.contacts.count })
    end

    it { expect { addressbook.create_contact(new_contact) }.not_to(change(User, :count)) }
  end

  describe '#updated_at' do
    it { expect(addressbook.updated_at).to eq([users[0], users[2]].map(&:updated_at).max.to_i) }
  end

  describe '#created_at' do
    it { expect(addressbook.created_at).to eq(group.created_at.to_i) }
  end
end
