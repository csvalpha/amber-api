class BookPolicy < ApplicationPolicy
  def generate_alias?
    create? or update?
  end
end
