class MailAliasPolicy < ApplicationPolicy
  def create_with_group?(_group)
    true
  end

  def replace_group?(_group)
    true
  end

  def create_with_user?(_user)
    true
  end

  def replace_user?(_user)
    true
  end
end
