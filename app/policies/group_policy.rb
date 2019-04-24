class GroupPolicy < ApplicationPolicy
  def update?
    scope.active_groups_for_user(user).exists?(record.id) || super
  end

  def export?
    user.permission?(:read, record)
  end

  def create_with_permissions?(_permissions)
    true
  end

  def replace_permissions?(_permissions)
    true
  end
end
