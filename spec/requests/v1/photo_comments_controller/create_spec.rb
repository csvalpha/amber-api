require 'rails_helper'

describe V1::PhotoCommentsController do
  describe 'POST /photo_comments', version: 1 do
    let(:record) { create(:photo_comment) }
    let(:record_url) { '/v1/photo_comments' }
    let(:record_permission) { 'photo_comment.create' }

    it_behaves_like 'a creatable and permissible model' do
      let(:valid_attributes) { record.attributes }
      let(:valid_relationships) do
        {
          photo: { data: { id: record.photo_id, type: 'photos' } }
        }
      end
      let(:invalid_relationships) do
        {
          photo: { data: { id: nil, type: 'photos' } }
        }
      end
    end

    context 'when authenticated' do
      let(:another_user) { create(:user) }
      let(:valid_request) do
        post(
          record_url,
          data: {
            id: record.id,
            type: record_type(record),
            attributes: record.attributes,
            relationships: {
              photo: { data: { id: record.photo_id, type: 'photos' } },
              user: { data: { id: another_user.id, type: 'users' } }
            }
          }
        )
      end

      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before { valid_request }

      it { expect(valid_request.status).to eq(201) }
      it { expect(record.class.last.author).to eq(user) }
    end
  end
end
