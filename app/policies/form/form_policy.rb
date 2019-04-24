module Form
  class FormPolicy < ApplicationPolicy
    def update?
      record.owners.include?(user) || super
    end
  end
end
