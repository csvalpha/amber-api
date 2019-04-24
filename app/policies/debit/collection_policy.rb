module Debit
  class CollectionPolicy < ApplicationPolicy
    def sepa?
      create?
    end
  end
end
