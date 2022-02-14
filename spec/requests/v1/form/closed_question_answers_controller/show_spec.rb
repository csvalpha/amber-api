require 'rails_helper'

describe V1::Form::ClosedQuestionAnswersController do
  describe 'GET /form/closed_question_answers/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:closed_question_answer) }
      let(:record_url) { "/v1/form/closed_question_answers/#{record.id}" }
      let(:record_permission) { 'form/closed_question_answer.read' }
    end
  end
end
