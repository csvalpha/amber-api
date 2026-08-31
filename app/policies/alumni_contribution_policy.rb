class AlumniContributionPolicy < ApplicationPolicy
  def index?
    user_can_read?
  end

  def show?
    user_can_read?
  end

  def create?
    user_can_create?
  end

  def update?
    user_can_update?
  end

  def destroy?
    user_can_update?
  end

  private

  def user_can_read?
    user&.permission?(:read, record) || record.user == user
  end

  def user_can_create?
    user&.permission?(:create, record)
  end

  def user_can_update?
    user&.permission?(:update, record) || record.user == user
  end
end
