require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'DELETE /form/responses/:id', version: 1 do
    let(:form) { create(:form) }

    let(:record) { create(:response, form:) }
    let(:record_url) { "/v1/form/responses/#{record.id}" }
    let(:record_permission) { 'form/response.destroy' }

    let(:open_question) { create(:open_question, form:) }
    let(:closed_question) { create(:closed_question, form:) }
    let(:closed_question_option) do
      create(:closed_question_option, question: closed_question)
    end

    before do
      open_question
      closed_question
      closed_question_option
    end

    it_behaves_like 'a destroyable and permissible model'

    context 'when destroy without permission' do
      subject(:request) { delete(record_url) }

      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: []) }
      end
      let(:record) { create(:response, form:, user:) }

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.class.count }.by(-1)) }

      context 'when destroy someone elses record' do
        let(:another_user) { create(:user, user_permission_list: []) }
        let(:record) { create(:response, form:, user: another_user) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
