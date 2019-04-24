module Form
  class ClosedQuestionAnswerPolicy < ApplicationPolicy
    def destroy?
      owner? || super
    end

    def create_with_option?(_response)
      true
    end

    def replace_option?(_response)
      true
    end

    def create_with_response?(_question)
      true
    end

    def replace_response?(_true)
      true
    end

    private

    def owner?
      record.response.user == user
    end
  end
end
