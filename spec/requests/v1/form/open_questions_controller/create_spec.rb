require 'rails_helper'

describe V1::Form::OpenQuestionsController do
  describe 'POST /form/open_questions/:id', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { FactoryBot.create(:open_question) }
      let(:record_url) { '/v1/form/open_questions' }
      let(:record_permission) { 'form/open_question.create' }
      let(:valid_relationships) { { form: { data: { id: record.form_id, type: 'forms' } } } }
      let(:invalid_relationships) { { form: { data: { id: nil, type: 'forms' } } } }
    end
  end
end
