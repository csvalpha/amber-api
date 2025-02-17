class SidekiqPolicy < ApplicationPolicy
  def access?
    user&.can?("read", "Sidekiq")
  end
end
