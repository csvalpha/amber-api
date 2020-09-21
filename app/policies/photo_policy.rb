class PhotoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user_can_read?
        scope.includes(:photo_album)
      else
        scope.publicly_visible.includes(:photo_album)
      end
    end
  end

  def index?
    true
  end

  def get_related_resources? # rubocop:disable Naming/AccessorMethodName
    index?
  end

  def show?
    scope.exists?(id: record.id)
  end
end
