module Form
  class ClosedQuestionOptionPolicy < ApplicationPolicy
    def update?
      owner? || super
    end

    def destroy?
      owner? || super
    end

    def create_with_question?(_question)
      true
    end

    def replace_question?(_question)
      true
    end

    private

    def owner?
      record.question.form.owners.include?(user)
    end
  end
end
