require 'rails_helper'

RSpec.describe Form::ClosedQuestionAnswerPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:response) { FactoryBot.build_stubbed(:response, user: user) }

  permissions :destroy? do
    describe 'when closed question option is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:closed_question_answer)) }
    end

    describe 'when closed question option is owned' do
      it do
        expect(policy).to permit(user, FactoryBot.build_stubbed(:closed_question_answer,
                                                                response: response))
      end
    end

    describe 'when with permission' do
      let(:record_permission) { 'form/closed_question_answer.destroy' }
      let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }

      it do
        expect(policy).to permit(user, FactoryBot.build_stubbed(:closed_question_answer,
                                                                response: response))
      end
    end
  end
end
