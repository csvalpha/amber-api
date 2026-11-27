class PhotoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(photo_album: albums)
    end

    private

    def albums
      return PhotoAlbum.publicly_visible unless user_can_read?

      PhotoAlbumPolicy::Scope.new(user, PhotoAlbum).readable_albums
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
