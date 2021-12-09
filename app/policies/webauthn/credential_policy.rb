module Webauthn
  class CredentialPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(user_id: user)
      end
    end

    def index?
      true
    end

    def show?
      scope.exists?(id: record.id)
    end

    def create?
      current_user
    end
  end
end
