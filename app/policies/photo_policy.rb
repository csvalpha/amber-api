class PhotoPolicy < ApplicationPolicy
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

  def get_related_resources?
    index?
  end

  def show?
    scope.exists?(id: record.id)
  end
end
