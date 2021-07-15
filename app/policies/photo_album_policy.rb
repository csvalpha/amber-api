class PhotoAlbumPolicy < ApplicationPolicy
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
    record.owners.include?(user) || super
  end

  def dropzone?
    user.permission?(:create, Photo)
  end

  def create_with_group?(_group)
    true
  end

  def replace_group?(_group)
    true
  end
end
