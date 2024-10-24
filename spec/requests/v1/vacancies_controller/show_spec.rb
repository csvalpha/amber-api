require 'rails_helper'

describe V1::VacanciesController do
  describe 'GET /vacancies/:id', version: 1 do
    subject(:request) { get(record_url) }

    let(:record) { create(:vacancy) }
    let(:record_url) { "/v1/vacancies/#{record.id}" }
    let(:record_permission) { 'vacancy.read' }

    it_behaves_like 'a permissible model'
  end
end
