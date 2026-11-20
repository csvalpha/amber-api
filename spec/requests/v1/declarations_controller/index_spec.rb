require 'rails_helper'

describe V1::DeclarationsController do
  describe 'GET /declarations', version: 1 do
    let(:records) { create_list(:declaration, 3) }
    let(:record_url) { '/v1/declarations' }
    let(:record_permission) { 'declaration.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'
    it_behaves_like 'a searchable model', %i[description]

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated as owner' do
      include_context 'when authenticated' do
        let(:user) { records.first.user }
      end

      it_behaves_like '200 OK'
      it { expect(json_object_ids).to contain_exactly(records.first.id) }
      it { expect(json['data'].first['attributes']).not_to have_key('receipt') }
      it { expect(json['data'].first['attributes']).to include('paid_amount', 'open_amount', 'has_receipt') }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before { records }

      it_behaves_like '200 OK'
      it { expect(json_object_ids).to match_array(records.map(&:id)) }

      it_behaves_like 'a filterable model for', %i[user]

      context 'when filtering on status' do
        let(:approved) { create(:declaration, :approved) }
        let(:request) { get("#{record_url}?filter[status]=approved") }

        before { approved }

        it { expect(json_object_ids).to contain_exactly(approved.id) }
      end
    end
  end
end
