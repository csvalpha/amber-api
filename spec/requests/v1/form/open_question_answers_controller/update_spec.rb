require 'rails_helper'

describe V1::Form::OpenQuestionAnswersController do
  describe 'PUT /form/open_question_answers/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { FactoryBot.create(:open_question_answer) }
      let(:record_url) { "/v1/form/open_question_answers/#{record.id}" }
      let(:record_permission) { 'form/open_question_answer.update' }
      let(:valid_relationships) do
        {
          response: {
            data: { id: record.response_id, type: 'responses' }
          },
          question: {
            data: { id: record.question_id, type: 'open_questions' }
          }
        }
      end
      let(:invalid_relationships) { { response: { data: { id: nil, type: 'responses' } } } }
    end
  end
end
