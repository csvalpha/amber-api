require 'rails_helper'

describe V1::DeclarationsController do
  describe 'GET /declarations/:id', version: 1 do
    let(:record) { create(:declaration) }
    let(:record_url) { "/v1/declarations/#{record.id}" }
    let(:record_permission) { 'declaration.read' }

    it_behaves_like 'a permissible model'

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      let(:request) { get(record_url) }

      it_behaves_like '200 OK'
    end

    context 'when including the settlements' do
      include_context 'when authenticated' do
        let(:user) { record.user }
      end

      let(:record) { create(:declaration, :approved, status: :partially_paid) }
      let(:transaction) { create(:transaction, declaration: record, user: record.user, amount: -5) }
      let(:request) { get("#{record_url}?include=transactions") }

      before do
        transaction
        create(:transaction, user: record.user) # not a settlement of this declaration
      end

      it_behaves_like '200 OK'
      it { expect(json['included'].pluck('id')).to contain_exactly(transaction.id.to_s) }
    end
  end
end
