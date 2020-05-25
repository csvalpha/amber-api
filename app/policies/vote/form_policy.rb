module Vote
  class FormPolicy < ApplicationPolicy
    def update?
      record.author == user || super
    end
  end
end
