require 'rails_helper'

RSpec.describe Form::ClosedQuestionAnswerPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }
  let(:response) { build_stubbed(:response, user:) }

  permissions :destroy? do
    describe 'when closed question option is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:closed_question_answer)) }
    end

    describe 'when closed question option is owned' do
      it do
        expect(policy).to permit(user, build_stubbed(:closed_question_answer,
                                                     response:))
      end
    end

    describe 'when with permission' do
      let(:record_permission) { 'form/closed_question_answer.destroy' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it do
        expect(policy).to permit(user, build_stubbed(:closed_question_answer,
                                                     response:))
      end
    end
  end
end
