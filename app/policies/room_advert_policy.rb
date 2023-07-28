class RoomAdvertPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user_can_read?
        scope
      else
        scope.publicly_visible
      end
    end
  end

  def update?
    user_is_owner? || super
  end

  def destroy?
    user_is_owner? || super
  end

  def archive?
    user_is_owner? || super
  end

  private

  def user_is_owner?
    record.author == user
  end
end
