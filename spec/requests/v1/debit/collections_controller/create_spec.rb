require 'rails_helper'

describe V1::Debit::CollectionsController do
  describe 'POST /debit/collections', version: 1 do
    let(:record) { FactoryBot.build(:collection) }
    let(:record_url) { '/v1/debit/collections' }
    let(:record_permission) { 'debit/collection.create' }

    subject(:request) do
      post(record_url,
           data: {
             id: record.id,
             type: record_type(record),
             attributes: record.attributes
           })
    end

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { date: '' } }
    end

    describe 'file uploader' do
      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: ['debit/collection.create']) }
      end
      let(:test_file) { Rails.root.join('spec', 'support', 'files', 'collection_import.csv') }
      let(:encoded_file) { Base64.strict_encode64(File.read(test_file)) }
      let(:base64_data) { "data:text/csv;base64,#{encoded_file}" }
      let(:transaction_user) { FactoryBot.create(:user, username: 'bestuurder') }

      subject(:request) do
        post(record_url,
             data: {
               id: record.id,
               type: record_type(record),
               attributes: record.attributes.merge!(
                 'import_file' => base64_data
               )
             })
      end

      before { transaction_user && request }

      it do
        expect(CollectionImportJob).to(have_been_enqueued.with(base64_data,
                                                               record.class.last, user))
      end
    end
  end
end
