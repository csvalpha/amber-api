class Webauthn::ChallengePolicy < ApplicationPolicy
  def create?
    current_user
  end
end
