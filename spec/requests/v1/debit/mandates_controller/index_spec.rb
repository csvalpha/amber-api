require 'rails_helper'

describe V1::Debit::MandatesController do
  describe 'GET /debit/mandates', version: 1 do
    let(:records) { FactoryBot.create_list(:mandate, 3) }
    let(:record_url) { '/v1/debit/mandates' }
    let(:record_permission) { 'debit/mandate.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[iban iban_holder]

    describe 'permissible model where user can access own records' do
      context 'when authenticated' do
        include_context 'when authenticated' do
          let(:user) { records.first.user }
        end

        it_behaves_like '200 OK'
        it { expect(json_object_ids).to contain_exactly(records.first.id) }
      end

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) do
            FactoryBot.create(:user, user_permission_list: ['debit/mandate.read'])
          end
        end
        before { records }

        it_behaves_like '200 OK'
        it { expect(json_object_ids).to match_array(records.map(&:id)) }
      end
    end
  end
end
