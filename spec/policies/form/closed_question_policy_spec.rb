require 'rails_helper'

RSpec.describe Form::ClosedQuestionPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }
  let(:form) { build_stubbed(:form, author: user) }

  permissions :update?, :destroy? do
    describe 'when closed question option is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:closed_question)) }
    end

    describe 'when closed question option is owned' do
      it { expect(policy).to permit(user, build_stubbed(:closed_question, form: form)) }
    end
  end

  permissions :update? do
    let(:record_permission) { 'form/closed_question.update' }

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:closed_question, form: form)) }
    end
  end

  permissions :destroy? do
    let(:record_permission) { 'form/closed_question.destroy' }

    describe 'when with permission' do
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:closed_question, form: form)) }
    end
  end
end
