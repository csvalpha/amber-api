module Vote
  class ResponsePolicy < ApplicationPolicy
    def create_with_form?(_form)
      true
    end

    def replace_form?(_form)
      true
    end
  end
end
