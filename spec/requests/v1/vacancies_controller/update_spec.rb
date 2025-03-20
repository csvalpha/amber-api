require 'rails_helper'

describe V1::VacanciesController do
  describe 'PUT /vacancies/:id', version: 1 do
    let(:record) { create(:vacancy) }
    let(:record_url) { "/v1/vacancies/#{record.id}" }
    let(:record_permission) { 'vacancy.update' }

    it_behaves_like 'an updatable and permissible model', response: :ok do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'an updatable model with group'

    context 'when with permission' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      subject(:request) { put(record_url) }

      it { expect { request && record.reload }.not_to(change(record, :author)) }
    end
  end
end
