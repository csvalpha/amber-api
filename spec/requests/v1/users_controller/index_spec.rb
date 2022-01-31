require 'rails_helper'

describe V1::UsersController do
  describe 'GET /users', version: 1 do
    let(:records) { create_list(:user, 3) }
    let(:record_url) { '/v1/users' }
    let(:record_permission) { 'user.read' }
    let(:request) { get(record_url) }

    it_behaves_like 'an indexable model'

    context 'search' do
      before { Bullet.enable = false }

      after { Bullet.enable = true }

      it_behaves_like 'a searchable model', %i[email first_name last_name last_name_prefix study]
    end

    context 'when with filter me' do
      include_context 'when authenticated' do
        let(:group) { create(:group) }
        let(:user) { create(:user, groups: [group]) }
      end
      let(:record_url) { '/v1/users?filter[me]' }

      it { expect(json_object_ids).to contain_exactly(user.id) }

      context 'when including active groups' do
        let(:record_url) { '/v1/users?filter[me]&include="active_groups"' }
        let(:user) do
          create(:user, groups: [group],
                        user_permission_list: %w[user.read group.read])
        end

        it do
          expect(
            json['data'].first['relationships']['active_groups']['data'].first['id'].to_i
          ).to be group.id
        end
      end
    end
  end
end
