require 'rails_helper'

describe V1::Form::ClosedQuestionAnswersController do
  describe 'PUT /form/closed_question_answers/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { FactoryBot.create(:closed_question_answer) }
      let(:record_url) { "/v1/form/closed_question_answers/#{record.id}" }
      let(:record_permission) { 'form/closed_question_answer.update' }
      let(:valid_relationships) do
        {
          option: { data: { id: record.option_id, type: 'closed_question_options' } },
          response: { data: { id: record.response_id, type: 'responses' } }
        }
      end
      let(:invalid_relationships) do
        {
          option: {
            data: {
              id: nil,
              type: 'closed_question_options'
            }
          }
        }
      end
    end
  end
end
