require 'rails_helper'

describe V1::Form::OpenQuestionsController do
  describe 'GET /form/open_questions', version: 1 do
    let(:records) { create_list(:open_question, 3) }
    let(:record_url) { '/v1/form/open_questions' }
    let(:record_permission) { 'form/open_question.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
