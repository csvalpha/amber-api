require 'rails_helper'

describe V1::Form::OpenQuestionAnswersController do
  describe 'GET /form/open_question_answers', version: 1 do
    let(:records) { create_list(:open_question_answer, 3) }
    let(:record_url) { '/v1/form/open_question_answers' }
    let(:record_permission) { 'form/open_question_answer.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'a permissible model'
    it_behaves_like 'an indexable model'
  end
end
