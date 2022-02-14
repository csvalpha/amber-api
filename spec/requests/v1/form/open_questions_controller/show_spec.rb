require 'rails_helper'

describe V1::Form::OpenQuestionsController do
  describe 'GET /form/open_questions/:id', version: 1 do
    it_behaves_like 'a permissible model' do
      let(:record) { create(:open_question) }
      let(:record_url) { "/v1/form/open_questions/#{record.id}" }
      let(:record_permission) { 'form/open_question.read' }
    end
  end
end
