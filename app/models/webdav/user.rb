module Webdav
  class User
    attr_accessor :current_contact

    def initialize(user, book_id)
      @user = user
      @book_id = book_id
    end

    def all_addressbooks
      @user.active_groups.map do |group|
        Webdav::Addressbook.new(group)
      end
    end

    def current_addressbook
      group = @user.active_groups.find(@book_id)
      return unless group

      @current_addressbook = Webdav::Addressbook.new(group)
    end
  end
end
