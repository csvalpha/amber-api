require 'rails_helper'

RSpec.describe Webdav::Contact, type: :model do
  let(:user) { build_stubbed(:user) }

  subject(:contact) { described_class.new(user) }

  describe '#uid' do
    it { expect(contact.uid).to eq(user.id.to_s) }
  end

  describe '#path' do
    it { expect(contact.path).to eq(user.id.to_s) }
  end

  describe '#update_from_vcard()' do
    let(:other_user) { build_stubbed(:user) }
    let(:other_vcard) { described_class.user_to_vcard(other_user) }

    it { expect { contact.update_from_vcard(other_vcard) }.not_to(change(user, :first_name)) }
  end

  describe '#save' do
    it { expect { contact.save(nil) }.not_to(change(user, :updated_at)) }
  end

  describe '#destroy' do
    it { expect { contact.destroy }.not_to(change(User, :count)) }
  end

  describe '#etag' do
    it { expect(contact.etag).to eq(user.updated_at.to_i) }
  end

  describe '#created_at' do
    it { expect(contact.created_at).to eq(user.created_at.to_i) }
  end

  describe '#updated_at' do
    it { expect(contact.updated_at).to eq(user.updated_at.to_i) }
  end

  describe '#vcard' do
    let(:vcard) { described_class.user_to_vcard(user) }

    it { expect(contact.vcard).not_to be_nil }
    it { expect(contact.vcard.vcard).to eq(vcard.to_s) }
    it { expect(contact.vcard.to_s).to eq(vcard.to_s) }
  end

  describe '#user_to_vcard' do
    let(:time_now) { Time.zone.now }

    subject(:vcard) { described_class.user_to_vcard(user) }

    it { expect(vcard.name.given).to eq(user.first_name) }
    it { expect(vcard.name.family).to eq(user.last_name) }
    it { expect(vcard.name.additional).to eq(user.last_name_prefix || '') }
    it { expect(vcard.birthday).to eq(user.birthday) }
    it { expect(vcard.address.location).to eq(['home']) }
    it { expect(vcard.address.street).to eq(user.address) }
    it { expect(vcard.address.locality).to eq(user.city) }
    it { expect(vcard.address.postalcode).to eq(user.postcode) }
    it { expect(vcard.email).to eq(user.email) }
    it { expect(vcard.telephones.first).to eq(user.phone_number) }
    # Testing REV doesnt work on CI, this gives an timing issue
    # it { expect(Time.parse(vcard.field('REV').value).to_i).to eq(time_now.to_i) }
    it { expect(vcard.field('PRODID').value).to eq('C.S.V. Alpha') }
  end
end
