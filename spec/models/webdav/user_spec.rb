require 'rails_helper'

RSpec.describe Webdav::User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:group) { FactoryBot.create(:group, users: [user]) }

  subject(:webdav_user) { Webdav::User.new(user, group.id) }

  describe '#current_addressbook' do
    it { expect(webdav_user.current_addressbook.name).to eq(group.name) }
  end

  describe '#all_addressbooks' do
    it { expect(webdav_user.all_addressbooks.size).to eq(user.active_groups.size) }
    it { expect(webdav_user.all_addressbooks[0].name).to eq(group.name) }
  end

  describe '#current_contact' do
    before { webdav_user.current_contact = Webdav::Contact.new(user) }

    it { expect(webdav_user.current_contact).not_to be_nil }
    it { expect(webdav_user.current_contact.uid).to eq(user.id.to_s) }
  end
end
