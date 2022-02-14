require 'rails_helper'

describe V1::Form::ClosedQuestionsController do
  describe 'POST /form/closed_questions/:id', version: 1 do
    it_behaves_like 'a creatable and permissible model' do
      let(:record) { create(:closed_question) }
      let(:record_url) { '/v1/form/closed_questions' }
      let(:record_permission) { 'form/closed_question.create' }
      let(:valid_relationships) { { form: { data: { id: record.form_id, type: 'forms' } } } }
      let(:invalid_relationships) { { form: { data: { id: nil, type: 'forms' } } } }
    end
  end
end
