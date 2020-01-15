class QuickpostStatisticPolicy < ApplicationPolicy
  def index?
    user&.permission?(:read, QuickpostMessage)
  end
end
