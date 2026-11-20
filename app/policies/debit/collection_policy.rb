module Debit
  class CollectionPolicy < ApplicationPolicy
    def sepa?
      create?
    end

    def finalize?
      create?
    end

    # A finalized collection holds the definitive declaration settlements, removing it would lose them
    def destroy?
      super && !record.finalized?
    end
  end
end
