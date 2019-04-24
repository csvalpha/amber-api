class StoredMailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user_can_read?
        scope
      else
        scope.stored_mails_moderated_by_user(user)
      end
    end
  end

  def index?
    true
  end

  def show?
    moderator? || super
  end

  def destroy?
    # all destroy, accept and reject actions remove the stored mail,
    # so their policies are equal
    moderator? || super
  end

  def accept?
    # all destroy, accept and reject actions remove the stored mail,
    # so their policies are equal
    destroy?
  end

  def reject?
    # all destroy, accept and reject actions remove the stored mail,
    # so their policies are equal
    destroy?
  end

  private

  def moderator?
    record.mail_alias.moderators.include?(user)
  end
end
