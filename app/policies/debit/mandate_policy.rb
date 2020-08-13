module Debit
  class MandatePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user_can_read?
          scope
        else
          scope.mandates_for(user)
        end
      end
    end

    def index?
      user
    end

    def show?
      scope.exists?(id: record.id)
    end

    def create_with_user?(_user)
      true
    end

    def replace_user?(_user)
      true
    end
  end
end
