require 'rails_helper'

describe V1::ActivitiesController do
  describe 'PUT /activities/:id', version: 1 do
    let(:record_permission) { 'activity.update' }
    let(:record) { FactoryBot.create(:activity, :with_form) }
    let(:record_url) { "/v1/activities/#{record.id}" }

    # it_behaves_like 'an updatable and permissible model', response: :ok do
    #   let(:valid_relationships) do
    #     { form: { data: { id: record.form_id, type: 'forms' } } }
    #   end
    #   let(:invalid_attributes) { { price: -35 } }
    # end

    it_behaves_like 'an updatable model with group' do
      before { Bullet.enabled = false}
      after { Bullet.enabled = true}
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) do
        put(record_url, data: {
              id: record.id,
              type: record_type(record)
            })
      end


      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
