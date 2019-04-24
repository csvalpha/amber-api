require 'rails_helper'

# rubocop:disable DescribeClass
describe 'DAV4Rack::Carddav::Controller for DAV4Rack::Carddav::AddressbookCollectionResource' do
  # rubocop:enable DescribeClass
  describe 'PROPFIND /webdav/:user_id/:key/contacts/books', version: 1 do
    let(:users) { FactoryBot.create_list(:user, 4, :webdav_enabled, activated_at: Time.zone.now) }
    let(:user) { users.first }
    let(:group) do
      FactoryBot.create(:group, users: users)
    end

    before { group }

    context 'when requesting resourcetype and displayname' do
      let(:request_data) do
        '<A:propfind xmlns:A="DAV:">
          <A:prop><A:resourcetype/><A:displayname/></A:prop>
         </A:propfind>'
      end

      context 'when with invalid secret' do
        let(:request_url) { "/webdav/#{user.id}/invalidsecret/contacts/books" }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        it_behaves_like '404 Not Found'
      end

      context 'when with valid secret' do
        let(:request_url) { "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books" }
        let(:xml) { Hash.from_xml(request.body) }
        let(:responses) { xml['multistatus']['response'] }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        # For an example response see https://github.com/csvalpha/amber-api/wiki/CardDAV-explained-with-examples
        it_behaves_like '207 Multistatus'
        it { expect(responses.length).to eq(6) }
        # Second response is the addressbook
        it {
          expect(responses[1]['href'])
            .to eq("/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{group.id}/")
        }
        it {
          expect(responses[1]['propstat']['prop']['resourcetype'].keys)
            .to contain_exactly('collection', 'addressbook')
        }
        it { expect(responses[1]['propstat']['prop']['displayname']).to eq group.name }
        # third to fifth responses are members
        it {
          expect(responses[2..5].map { |r| r['href'] })
            .to match_array(group.users.map do |u|
              "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{group.id}/#{u.id}"
            end)
        }
        it {
          expect(responses[2..5].map { |r| r['propstat']['prop']['displayname'] })
            .to match_array(group.users.map { |u| u.id.to_s })
        }
      end
    end
  end
end
