require 'rails_helper'

describe V1::Form::FormsController do
  describe 'PUT /form/forms/:id', version: 1 do
    let(:record) { create(:form, :with_author) }
    let(:record_url) { "/v1/form/forms/#{record.id}" }
    let(:record_permission) { 'form/form.update' }

    it_behaves_like 'an updatable and permissible model' do
      let(:invalid_attributes) { { respond_from: '' } }
    end

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end

    context 'when user is author' do
      include_context 'when authenticated' do
        let(:user) { record.author }
      end

      subject(:request) do
        put(record_url,
            data: {
              id: record.id,
              type: record_type(record)
            })
      end

      it_behaves_like '200 OK'
    end
  end
end
