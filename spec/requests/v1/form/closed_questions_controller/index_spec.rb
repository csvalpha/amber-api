require 'rails_helper'

describe V1::Form::ClosedQuestionsController do
  describe 'GET /form/closed_questions', version: 1 do
    let(:records) { create_list(:closed_question, 3) }
    let(:record_url) { '/v1/form/closed_questions' }
    let(:record_permission) { 'form/closed_question.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
