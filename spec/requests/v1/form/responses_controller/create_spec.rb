require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'POST /form/responses/:id', version: 1 do
    let(:record) { create(:response) }
    let(:record_url) { '/v1/form/responses' }
    let(:record_permission) { 'form/response.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_relationships) do
        { form: { data: { id: record.form_id, type: 'forms' } } }
      end
      let(:invalid_relationships) do
        { form: { data: { id: nil, type: 'forms' } } }
      end
    end

    it_behaves_like 'a re-creatable model' do
      let(:user) do
        create(:user, user_permission_list: [record_permission])
      end
      let(:record) { create(:response, user: user) }
      let(:valid_relationships) do
        { form: { data: { id: record.form_id, type: 'forms' } } }
      end

      before { record.destroy }
    end

    context 'when authenticated' do
      let(:another_user) { create(:user) }
      let(:valid_request) do
        post(
          record_url,
          data: {
            id: record.id,
            type: record_type(record),
            relationships: { form: { data: { id: record.form_id, type: 'forms' } } },
            user: { data: { id: another_user.id, type: 'forms' } }
          }
        )
      end

      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before { valid_request }

      it { expect(record.class.last.user).to eq user }
    end
  end
end
