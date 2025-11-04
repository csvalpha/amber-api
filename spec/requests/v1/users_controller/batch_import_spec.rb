require 'rails_helper'

describe V1::UsersController do
  describe 'POST /users/batch_import', version: 1 do
    let(:test_file_path) { Rails.root.join('spec', 'support', 'files', 'user_import.csv') }
    let(:test_file_base64) { Base64.encode64(File.read(test_file_path)).delete("\n") }
    let(:test_file) { "data:text/csv;base64,#{test_file_base64}" }
    let(:record_url) { '/v1/users/batch_import' }
    let(:record_permission) { 'user.create' }
    let(:group) { create(:group) }
    let(:live_run) { nil }
    let(:params) { { group: group.id, file: test_file, live_run: } }

    subject(:request) { post(record_url, params) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
      it { expect { request }.not_to(change(User, :count)) }
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like '403 Forbidden'

      context 'when with permission' do
        include_context 'when authenticated' do
          let(:user) { create(:user, user_permission_list: [record_permission]) }
        end

        context 'when without parameters' do
          let(:params) { nil }

          it_behaves_like '422 Unprocessable Content'
          it { expect(group.users.count).to eq 0 }
        end

        context 'when with parameters' do
          it_behaves_like '200 OK'
          it { expect { request }.not_to(change(User, :count)) }
        end

        context 'when doing live_run' do
          let(:live_run) { 'true' }

          it { expect { request }.to(change { group.users.count }.from(0).to(3)) }
        end

        context 'when with incomplete headers' do
          let(:test_file_path) do
            Rails.root.join('spec', 'support', 'files',
                            'malformed_user_import_incomplete_headers.csv')
          end

          it { expect { request }.not_to(change { group.users.count }) }
          it { expect(request.body).to include 'first_name must be present in header' }
        end

        context 'when with incomplete row' do
          let(:test_file_path) do
            Rails.root.join('spec', 'support', 'files', 'malformed_user_import.csv')
          end

          it { expect { request }.not_to(change { group.users.count }) }
          it { expect(request.body).to include 'Fout in rij 2' }
          it { expect(request.body).to include 'First name moet opgegeven zijn' }
        end

        context 'when with existing email' do
          let(:test_file_path) do
            Rails.root.join('spec', 'support', 'files', 'duplicate_user_import.csv')
          end

          before { create(:user, email: 'uniq@example.com') }

          it { expect { request }.not_to(change { group.users.count }) }
          it { expect(request.body).to include 'Email is al in gebruik' }
        end
      end
    end
  end
end
