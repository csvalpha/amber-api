class PhotoAlbumPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve # rubocop:disable Metrics/AbcSize
      if user_can_read?
        membership = user.memberships.joins(:group).where(groups: { name: 'Leden' }).first
        return scope.publicly_visible if membership.nil?

        scope.alumni_visible(
          membership.start_date&.advance(months: -18),
          membership.end_date&.advance(months: 6)
        )
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
