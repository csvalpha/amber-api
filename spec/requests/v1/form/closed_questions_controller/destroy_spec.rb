require 'rails_helper'

describe V1::Form::ClosedQuestionsController do
  describe 'DELETE /form/closed_questions/:id', version: 1 do
    let(:record) { FactoryBot.create(:closed_question) }
    let(:record_url) { "/v1/form/closed_questions/#{record.id}" }
    let(:record_permission) { 'form/closed_question.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
