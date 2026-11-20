require 'rails_helper'

RSpec.describe DeclarationPolicy, type: :policy do
  let(:owner) { create(:user) }
  let!(:own_declaration) { create(:declaration, user: owner) }
  let!(:other_declaration) { create(:declaration) }

  describe DeclarationPolicy::Scope do
    subject(:resolved) { described_class.new(user, Declaration.all).resolve }

    context 'when the user has read permission' do
      let(:user) { create(:user, user_permission_list: ['declaration.read']) }

      it { expect(resolved).to contain_exactly(own_declaration, other_declaration) }
    end

    context 'when the user is a member' do
      let(:user) { owner }

      it { expect(resolved).to contain_exactly(own_declaration) }
    end

    context 'when there is no user (e.g. an application token)' do
      let(:user) { Doorkeeper::Application.new }

      it { expect(resolved).to be_empty }
    end
  end
end
