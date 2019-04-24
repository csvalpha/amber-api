class PollPolicy < ApplicationPolicy
  def update?
    user_is_owner? || super
  end

  def create_with_form?(_form)
    true
  end

  def replace_form?(_form)
    true
  end

  private

  def user_is_owner?
    record.author == user
  end
end
