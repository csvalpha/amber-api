require 'rails_helper'

describe V1::Form::FormsController do
  describe 'POST /form/forms', version: 1 do
    let(:record) { FactoryBot.build(:form) }
    let(:record_url) { '/v1/form/forms' }
    let(:record_permission) { 'form/form.create' }

    subject(:request) do
      post(record_url,
           data: {
             id: record.id,
             type: record_type(record),
             attributes: record.attributes
           })
    end

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
      it { expect { request }.not_to(change { record.class.count }) }
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like '403 Forbidden'
      it { expect { request }.not_to(change { record.class.count }) }

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
        end

        before { request }

        it { expect(record.class.last.author).to eq(user) }
      end
    end
  end
end
