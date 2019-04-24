require 'rails_helper'

RSpec.describe Form::OpenQuestionAnswerPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build(:user) }
  let(:response) { FactoryBot.build(:response, user: user) }

  permissions :update? do
    describe 'when open question answer is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build(:open_question_answer)) }
    end

    describe 'when open question answer is owned' do
      it do
        expect(policy).to permit(user, FactoryBot.build(:open_question_answer,
                                                        response: response))
      end
    end

    describe 'when with permission' do
      let(:record_permission) { 'form/open_question_answer.update' }
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

      it do
        expect(policy).to permit(user, FactoryBot.build(:open_question_answer,
                                                        response: response))
      end
    end
  end
end
