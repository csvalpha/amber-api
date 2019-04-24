require 'rails_helper'

describe V1::Form::OpenQuestionsController do
  describe 'DELETE /form/open_questions/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { FactoryBot.create(:open_question) }
      let(:record_url) { "/v1/form/open_questions/#{record.id}" }
      let(:record_permission) { 'form/open_question.destroy' }
    end
  end
end
