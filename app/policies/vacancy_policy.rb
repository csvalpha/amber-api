class VacancyPolicy < ApplicationPolicy
  def update?
    record.owners.include?(user) || super
  end

  def create_with_group?(_group)
    true
  end

  def replace_group?(_group)
    true
  end
end
