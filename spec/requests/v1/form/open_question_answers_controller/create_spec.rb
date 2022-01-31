require 'rails_helper'

describe V1::Form::OpenQuestionAnswersController do
  describe 'POST /form/open_question_answers/:id', version: 1 do
    let(:record_url) { '/v1/form/open_question_answers' }
    let(:record_permission) { 'form/open_question_answer.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:record) do
        build(:open_question_answer, question: create(:open_question))
      end
      let(:valid_relationships) do
        {
          response: { data: { id: record.response_id, type: 'responses' } },
          question: { data: { id: record.question_id, type: 'open_questions' } }
        }
      end
      let(:invalid_relationships) { { response: { data: { id: nil, type: 'responses' } } } }
    end

    it_behaves_like 'a re-creatable model' do
      let(:record) { create(:open_question_answer) }
      let(:valid_relationships) do
        {
          response: { data: { id: record.response_id, type: 'responses' } },
          question: { data: { id: record.question_id, type: 'open_questions' } }
        }
      end

      before { record.destroy }
    end
  end
end
