require 'rails_helper'

describe V1::VacanciesController do
  describe 'DELETE /vacancies/:id', version: 1 do
    let(:record) { create(:vacancy) }
    let(:record_url) { "/v1/vacancies/#{record.id}" }
    let(:record_permission) { 'vacancy.destroy' }

    it_behaves_like 'a destroyable and permissible model'
  end
end
