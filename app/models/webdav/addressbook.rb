module Webdav
  class Addressbook
    def initialize(group)
      @group = group
    end

    delegate :name, to: :@group

    def path
      @group.id
    end

    def contacts
      @contacts ||= @group.active_users.contactsync_users.collect { |u| Webdav::Contact.new(u) }
    end

    def ctag
      updated_at.to_i
    end

    def find_contact(uid)
      contacts.detect { |c| c.uid == uid }
    end

    def find_contacts(ids)
      ids.each_with_object({}) do |(href, path), ret|
        uid = File.basename(path, '.vcf')
        ret[href] = contacts.detect { |c| c.uid == uid }
      end
    end

    def create_contact(*)
      true # no-op
    end

    def updated_at
      @group.active_users.maximum(:updated_at).to_i
    end

    def created_at
      @group.updated_at.to_i
    end
  end
end
