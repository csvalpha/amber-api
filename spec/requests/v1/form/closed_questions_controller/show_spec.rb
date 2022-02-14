require 'rails_helper'

describe V1::Form::ClosedQuestionsController do
  describe 'GET /form/closed_questions/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:closed_question) }
      let(:record_url) { "/v1/form/closed_questions/#{record.id}" }
      let(:record_permission) { 'form/closed_question.read' }
    end
  end
end
