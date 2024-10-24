require 'rails_helper'

describe V1::VacanciesController do
  describe 'POST /vacancies/:id', version: 1 do
    let(:record) { build_stubbed(:vacancy) }
    let(:record_url) { '/v1/vacancies' }
    let(:record_permission) { 'vacancy.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'a creatable model with group'
    it_behaves_like 'a creatable model with author'
  end
end
