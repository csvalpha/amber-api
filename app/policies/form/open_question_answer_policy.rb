module Form
  class OpenQuestionAnswerPolicy < ApplicationPolicy
    def update?
      owner? || super
    end

    def create_with_response?(_response)
      true
    end

    def replace_response?(_response)
      true
    end

    def create_with_question?(_question)
      true
    end

    def replace_question?(_true)
      true
    end

    private

    def owner?
      record.response.user == user
    end
  end
end
