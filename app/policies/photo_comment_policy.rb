class PhotoCommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user_can_read?
        membership = user.memberships.joins(:group).where(groups: { name: 'Leden' }).first
        return scope.none if membership.nil?

        scope.alumni_visible(
          membership.start_date&.advance(months: -18),
          membership.end_date&.advance(months: 6)
        )
      end
    end
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
