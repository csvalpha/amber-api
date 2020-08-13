class PhotoCommentPolicy < ApplicationPolicy
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

  def create_with_photo?(_photo)
    true
  end

  def replace_photo?(_photo)
    true
  end
end
