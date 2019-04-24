require 'rails_helper'

describe V1::Form::ClosedQuestionOptionsController do
  describe 'DELETE /form/closed_question_options/:id', version: 1 do
    it_behaves_like 'a destroyable and permissible model' do
      let(:record) { FactoryBot.create(:closed_question_option) }
      let(:record_url) { "/v1/form/closed_question_options/#{record.id}" }
      let(:record_permission) { 'form/closed_question_option.destroy' }
    end
  end
end
