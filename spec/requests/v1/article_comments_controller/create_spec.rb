require 'rails_helper'

describe V1::ArticleCommentsController do
  describe 'POST /article_comments', version: 1 do
    let(:record) { FactoryBot.create(:article_comment) }
    let(:record_url) { '/v1/article_comments' }
    let(:record_permission) { 'article_comment.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_attributes) { record.attributes }
      let(:valid_relationships) do
        {
          article: { data: { id: record.article_id, type: 'articles' } }
        }
      end
      let(:invalid_relationships) do
        {
          article: { data: { id: nil, type: 'articles' } }
        }
      end
    end

    context 'when authenticated' do
      let(:another_user) { FactoryBot.create(:user) }
      let(:valid_request) do
        post(
          record_url,
          data: {
            id: record.id,
            type: record_type(record),
            attributes: record.attributes,
            relationships: {
              article: { data: { id: record.article_id, type: 'articles' } },
              user: { data: { id: another_user.id, type: 'users' } }
            }
          }
        )
      end

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before { valid_request }

      it { expect(valid_request.status).to eq(201) }
      it { expect(record.class.last.author).to eq(user) }
    end
  end
end
