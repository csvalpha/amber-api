class VacancyPolicy < ApplicationPolicy
  def update?
    user_is_owner? || super
  end

  def user_is_owner?
    record.owners.include?(user)
  end
end