class ActivityPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user_can_read?
        scope
      else
        scope.publicly_visible
      end
    end
  end

  def index?
    true
  end

  def show?
    scope.exists?(id: record.id)
  end

  def update?
    user_is_owner? || super
  end

  def generate_alias?
    user_is_owner?
  end

  def create_with_form?(_form)
    true
  end

  def replace_form?(_form)
    true
  end

  def create_with_group?(_group)
    true
  end

  def replace_group?(_group)
    true
  end

  private

  def user_is_owner?
    record.owners.include?(user)
  end
end
