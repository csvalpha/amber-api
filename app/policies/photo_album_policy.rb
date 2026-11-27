class PhotoAlbumPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user_can_read? ? readable_albums : scope.publicly_visible
    end

    # Albums visible to a user with read permission, also used by the photo and photo comment policies.
    # Former members only see members-only albums from around their membership (issue #383).
    def readable_albums
      return scope.all if user.permission?(:update, PhotoAlbum)
      return scope.publicly_visible if leden_memberships.none?
      return scope.all if current_member?

      former_member_albums
    end

    private

    def former_member_albums
      scope.visible_in_period(leden_memberships.minimum(:start_date).advance(months: -18),
                              leden_memberships.maximum(:end_date).advance(months: 6))
    end

    def leden_memberships
      @leden_memberships ||= user.memberships.joins(:group).where(groups: { name: 'Leden' })
    end

    def current_member?
      leden_memberships.exists?(end_date: nil) || leden_memberships.maximum(:end_date).future?
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
