module Webauthn
  class ChallengePolicy < ApplicationPolicy
    def create?
      user
    end
  end
end
