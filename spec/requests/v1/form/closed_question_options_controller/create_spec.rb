require 'rails_helper'

describe V1::Form::ClosedQuestionOptionsController do
  describe 'POST /form/closed_question_options/:id', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { FactoryBot.create(:closed_question_option) }
      let(:record_url) { '/v1/form/closed_question_options' }
      let(:record_permission) { 'form/closed_question_option.create' }
      let(:valid_relationships) do
        {
          question: {
            data: { id: record.question_id, type: 'closed_questions' }
          }
        }
      end
      let(:invalid_relationships) do
        {
          question: { data: { id: nil, type: 'closed_questions' } }
        }
      end
    end
  end
end
