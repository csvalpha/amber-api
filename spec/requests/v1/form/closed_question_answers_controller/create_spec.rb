require 'rails_helper'

describe V1::Form::ClosedQuestionAnswersController do
  describe 'POST /form/closed_question_answers/:id', version: 1 do
    let(:record_url) { '/v1/form/closed_question_answers' }
    let(:record_permission) { 'form/closed_question_answer.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:record) { FactoryBot.build(:closed_question_answer) }
      let(:valid_attributes) { record.attributes.except(:question_id) }
      let(:valid_relationships) do
        {
          option: { data: { id: record.option_id, type: 'closed_question_options' } },
          response: { data: { id: record.response_id, type: 'responses' } }
        }
      end
      let(:invalid_relationships) do
        {
          option: { data: { id: nil, type: 'closed_question_options' } }
        }
      end
    end

    describe 'when it is checkbox typed' do
      it_behaves_like 'a re-creatable model' do
        let(:question) do
          FactoryBot.create(:closed_question, :with_options, field_type: :checkbox)
        end
        let(:response) { FactoryBot.create(:response, form: question.form) }
        let(:answers) do
          question.options.map do |option|
            FactoryBot.create(:closed_question_answer, option: option, response: response)
          end
        end
        let(:record) { answers.sample }
        let(:valid_relationships) do
          {
            option: { data: { id: record.option_id, type: 'closed_question_options' } },
            response: { data: { id: record.response_id, type: 'responses' } }
          }
        end

        before do
          Bullet.enable = false
          answers.each(&:destroy)
        end

        after { Bullet.enable = true }
      end
    end

    describe 'when it is radio typed' do
      it_behaves_like 'a re-creatable model' do
        let(:question) { FactoryBot.create(:closed_question, :with_options, field_type: :radio) }
        let(:response) { FactoryBot.create(:response, form: question.form) }
        let(:previous_answer) do
          FactoryBot.create(:closed_question_answer,
                            option: question.options.first,
                            response: response)
        end
        let(:record) do
          FactoryBot.build(:closed_question_answer,
                           option: question.options.second,
                           response: response)
        end
        let(:valid_relationships) do
          {
            option: { data: { id: record.option_id, type: 'closed_question_options' } },
            response: { data: { id: record.response_id, type: 'responses' } }
          }
        end

        before do
          Bullet.enable = false
          previous_answer.destroy
        end

        after { Bullet.enable = true }
      end
    end
  end
end
