require 'rails_helper'

RSpec.describe Form::FormPolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { FactoryBot.build_stubbed(:user) }

  permissions :update? do
    describe 'when form is not owned' do
      it { expect(policy).not_to permit(user, FactoryBot.build_stubbed(:form)) }
    end

    describe 'when form is owned' do
      it { expect(policy).to permit(user, FactoryBot.build_stubbed(:form, author: user)) }
    end
  end
end
