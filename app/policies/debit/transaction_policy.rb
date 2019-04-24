module Debit
  class TransactionPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user_can_read?
          scope
        elsif user
          scope.transactions_for(user)
        end
      end
    end

    def index?
      user
    end

    def show?
      scope.where(id: record.id).exists?
    end

    def create_with_user?(_user)
      true
    end

    def replace_user?(_user)
      true
    end

    def create_with_collection?(_collection)
      true
    end

    def replace_collection?(_collection)
      true
    end
  end
end
