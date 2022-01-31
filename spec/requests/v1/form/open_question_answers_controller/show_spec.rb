require 'rails_helper'

describe V1::Form::OpenQuestionAnswersController do
  describe 'GET /form/open_question_answers/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:open_question_answer) }
      let(:record_url) { "/v1/form/open_question_answers/#{record.id}" }
      let(:record_permission) { 'form/open_question_answer.read' }
    end
  end
end
