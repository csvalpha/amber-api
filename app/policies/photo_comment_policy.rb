class PhotoCommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # Photo comments are never public, readers see the comments of the photo albums they can see
    def resolve
      return scope.none unless user_can_read?

      scope.where(photo: Photo.where(photo_album: PhotoAlbumPolicy::Scope.new(user, PhotoAlbum).readable_albums))
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
