require 'rails_helper'

RSpec.describe Form::OpenQuestionPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }
  let(:form) { build_stubbed(:form, author: user) }

  permissions :update?, :destroy? do
    describe 'when open question option is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:open_question)) }
    end

    describe 'when open question option is owned' do
      it { expect(policy).to permit(user, build_stubbed(:open_question, form:)) }
    end
  end

  permissions :update? do
    describe 'when with permission' do
      let(:record_permission) { 'form/open_question.update' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:open_question, form:)) }
    end
  end

  permissions :destroy? do
    describe 'when with permission' do
      let(:record_permission) { 'form/open_question.destroy' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:open_question, form:)) }
    end
  end
end
