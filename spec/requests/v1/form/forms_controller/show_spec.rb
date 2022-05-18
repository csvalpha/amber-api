require 'rails_helper'

describe V1::Form::FormsController do
  describe 'GET /form/forms/:id', version: 1 do
    let(:record) { create(:form) }
    let(:record_url) { "/v1/form/forms/#{record.id}" }
    let(:record_permission) { 'form/form.read' }
    let(:user) { create(:user, user_permission_list: [record_permission]) }

    it_behaves_like 'a permissible model'

    context 'when authenticated and with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      context 'when user has not responded' do
        before do
          create(:response, form: record)
        end

        subject(:request) { get(record_url) }

        it { expect(json['data']['attributes']['current_user_response_id']).to be_nil }
        it { expect(json['data']['attributes']['current_user_response_completed']).to be_nil }
      end

      context 'when user has incompleted response' do
        let(:response) do
          response = create(:response, form: record, user:)
          response.update(completed: false)
          response
        end

        before { response }

        subject(:request) { get(record_url) }

        it { expect(json['data']['attributes']['current_user_response_id']).to be response.id }
        it { expect(json['data']['attributes']['current_user_response_completed']).to be false }
      end

      context 'when user has completed response' do
        let(:response) do
          create(:response, form: record, user:)
        end

        before { response }

        subject(:request) { get(record_url) }

        it { expect(json['data']['attributes']['current_user_response_id']).to be response.id }
        it { expect(json['data']['attributes']['current_user_response_completed']).to be true }
      end
    end
  end
end
