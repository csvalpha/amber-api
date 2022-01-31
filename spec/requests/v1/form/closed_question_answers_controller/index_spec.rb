require 'rails_helper'

describe V1::Form::ClosedQuestionAnswersController do
  describe 'GET /form/closed_question_answers', version: 1 do
    let(:records) { create_list(:closed_question_answer, 3) }
    let(:record_url) { '/v1/form/closed_question_answers' }
    let(:record_permission) { 'form/closed_question_answer.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
