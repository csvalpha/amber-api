require 'rails_helper'

RSpec.describe Form::ResponsePolicy, type: :policy do
  subject(:policy) { described_class }

  let(:user) { build_stubbed(:user) }

  permissions :destroy? do
    describe 'when response is not owned' do
      it { expect(policy).not_to permit(user, build_stubbed(:response)) }
    end

    describe 'when response is owned' do
      it { expect(policy).to permit(user, build_stubbed(:response, user: user)) }
    end

    describe 'when with permission' do
      let(:record_permission) { 'form/response.destroy' }
      let(:user) { create(:user, user_permission_list: [record_permission]) }

      it { expect(policy).to permit(user, build_stubbed(:response)) }
    end
  end
end
