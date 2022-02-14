require 'rails_helper'

describe V1::Form::ClosedQuestionOptionsController do
  describe 'PUT /form/closed_question_options/:id', version: 1 do
    it_behaves_like 'an updatable and permissible model' do
      let(:record) { create(:closed_question_option) }
      let(:record_url) { "/v1/form/closed_question_options/#{record.id}" }
      let(:record_permission) { 'form/closed_question_option.update' }
      let(:valid_relationships) do
        {
          question: {
            data: { id: record.question_id, type: 'closed_questions' }
          }
        }
      end
      let(:invalid_relationships) do
        {
          question: {
            data: { id: nil, type: 'closed_questions' }
          }
        }
      end
    end
  end
end
