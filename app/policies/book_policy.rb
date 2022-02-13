class BookPolicy < ApplicationPolicy
  def isbn_lookup?
    create? or update?
  end
end
