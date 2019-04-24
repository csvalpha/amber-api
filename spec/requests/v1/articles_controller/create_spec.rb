require 'rails_helper'

describe V1::ArticlesController do
  describe 'POST /articles/:id', version: 1 do
    let(:record) { FactoryBot.build_stubbed(:article) }
    let(:record_url) { '/v1/articles' }
    let(:record_permission) { 'article.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:invalid_attributes) { { title: '' } }
    end

    it_behaves_like 'a creatable model with group'

    context 'when authenticated' do
      let(:another_user) { FactoryBot.create(:user) }
      let(:request) do
        post(record_url,
             data: {
               type: record_type(record),
               attributes: record.attributes,
               relationships: {
                 user: { data: { id: another_user.id } }
               }
             })
      end

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before { request }

      it { expect(record.class.last.author).to eq(user) }
    end
  end
end
