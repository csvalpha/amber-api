require 'rails_helper'

RSpec.describe Form::OpenQuestionAnswerPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }
  let(:response) { build(:response, user:) }

  permissions :update? do
    describe 'when open question answer is not owned' do
      it { expect(policy).not_to permit(user, build(:open_question_answer)) }
    end

    describe 'when open question answer is owned' do
      it do
        expect(policy).to permit(user, build(:open_question_answer,
                                             response:))
      end
    end

    describe 'when with permission' do
      let(:record_permission) { 'form/open_question_answer.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it do
        expect(policy).to permit(user, build(:open_question_answer,
                                             response:))
      end
    end
  end
end
