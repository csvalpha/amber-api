module Form
  class ResponsePolicy < ApplicationPolicy
    def destroy?
      super || (record.user == user)
    end

    def create_with_form?(_form)
      true
    end

    def replace_form?(_form)
      true
    end
  end
end
