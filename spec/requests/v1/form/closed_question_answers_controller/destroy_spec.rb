require 'rails_helper'

describe V1::Form::ClosedQuestionAnswersController do
  describe 'DELETE /form/closed_question_answers/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { FactoryBot.create(:closed_question_answer) }
      let(:record_url) { "/v1/form/closed_question_answers/#{record.id}" }
      let(:record_permission) { 'form/closed_question_answer.destroy' }
    end
  end
end
