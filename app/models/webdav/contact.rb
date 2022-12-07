module Webdav
  class Contact
    def initialize(user)
      @user = user
    end

    def uid
      @user.id.to_s
    end

    def path
      uid
    end

    def update_from_vcard(*)
      true # no op
    end

    def save(*)
      true # no-op
    end

    def destroy
      true # no-op
    end

    def etag
      updated_at
    end

    def created_at
      @user.created_at.to_i
    end

    def updated_at
      @user.updated_at.to_i
    end

    def vcard
      Struct::Vcard.new(self.class.user_to_vcard(@user))
    end

    def self.user_to_vcard(user) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      Vpim::Vcard::Maker.make2 do |maker|
        maker.add_name do |name|
          name.given = user.first_name
          name.family = user.last_name
          name.additional = user.last_name_prefix if user.last_name_prefix
        end
        maker.nickname = user.nickname
        maker.birthday = user.birthday if user.birthday
        maker.add_addr do |address|
          address.location = 'home'
          address.street = user.address
          address.locality = user.city
          address.postalcode = user.postcode
        end
        maker.add_email(user.email)
        if user.phone_number
          maker.add_tel(user.phone_number) { |telephone| telephone.capability = %w[voice cell] }
        end
        maker.add_field(Vpim::DirectoryInfo::Field.create('REV', Time.zone.now))
        maker.add_field(Vpim::DirectoryInfo::Field.create('PRODID', 'C.S.V. Alpha'))
      end
    end
  end

  # The carddav library uses 2 methods to get the vcard representation:
  # contact.vcard.vcard and contact.vcard.to_s
  Struct.new('Vcard', :card) do
    def vcard
      to_s
    end

    def to_s(*)
      card.to_s
    end
  end
end
