class DeclarationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user_can_read?
        scope
      elsif user
        scope.where(user:)
      else
        scope.none
      end
    end
  end

  def index?
    user.present?
  end

  def show?
    owner? || super
  end

  def create?
    user.present?
  end

  # Members may change their own declaration until it is handled, the treasurer until it is paid or rejected.
  # Which fields may change once (partially) paid is enforced in the model.
  def update?
    return record.pending? if owner? && !treasurer?(:update)

    treasurer?(:update) && !record.paid? && !record.rejected?
  end

  def destroy?
    return record.pending? if owner? && !treasurer?(:destroy)

    treasurer?(:destroy) && (record.pending? || (record.approved? && record.transactions.none?))
  end

  def approve?
    treasurer?(:update) && record.pending?
  end

  def reject?
    approve?
  end

  def receipt?
    show?
  end

  def pdf?
    show? && record.approved_at.present? && !record.rejected?
  end

  private

  def owner?
    user.present? && record.user_id == user.id
  end

  def treasurer?(action)
    user&.permission?(action, record) || false
  end
end
