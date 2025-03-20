require 'rails_helper'

describe V1::RoomAdvertsController do
  describe 'PUT /room_adverts/:id', version: 1 do
    let(:record) { create(:room_advert) }
    let(:record_url) { "/v1/room_adverts/#{record.id}" }
    let(:record_permission) { 'room_advert.update' }

    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:invalid_attributes) { { house_name: '' } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
