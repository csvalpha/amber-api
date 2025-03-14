class PhotoPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve # rubocop:disable Metrics/AbcSize
      if user_can_read?
        membership = user.memberships.joins(:group).where(groups: { name: 'Leden' }).first
        return if membership.nil?

        scope.alumni_visible(
          membership.start_date&.advance(months: -18),
          membership.end_date&.advance(months: 6)
        )
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
