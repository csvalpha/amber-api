module Form
  class ClosedQuestionPolicy < ApplicationPolicy
    def update?
      owner? || super
    end

    def destroy?
      owner? || super
    end

    def create_with_form?(_form)
      true
    end

    def replace_form?(_form)
      true
    end

    private

    def owner?
      record.form.owners.include?(user)
    end
  end
end
