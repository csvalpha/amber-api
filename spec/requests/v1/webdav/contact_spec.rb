require 'rails_helper'

# rubocop:disable DescribeClass
describe 'DAV4Rack::Carddav::Controller for DAV4Rack::Carddav::ContactResource' do
  # rubocop:enable DescribeClass
  describe 'PROPFIND /webdav/:user_id/:key/contacts/books/:group_id/:contact_id', version: 1 do
    let(:users) { FactoryBot.create_list(:user, 4, :webdav_enabled, activated_at: Time.zone.now) }
    let(:user) { users.first }
    let(:group) do
      FactoryBot.create(:group, users: users)
    end

    before { group }

    context 'when requesting address data' do
      let(:request_data) do
        '<B:propfind xmlns:A="http://calendarserver.org/ns/" xmlns:B="DAV:"
                     xmlns:C="urn:ietf:params:xml:ns:carddav">
          <B:prop>
            <C:address-data/>
            <B:displayname/>
          </B:prop>
        </B:propfind>'
      end

      context 'when with invalid secret' do
        let(:request_url) do
          "/webdav/#{user.id}/invalidsecret/contacts/books/#{group.id}/#{group.users[0].id}"
        end

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        it_behaves_like '404 Not Found'
      end

      context 'when with valid secret' do
        let(:request_url) do
          "/webdav/#{user.id}/#{user.webdav_secret_key}" \
          "/contacts/books/#{group.id}/#{group.users[0].id}"
        end
        let(:xml) { Hash.from_xml(request.body) }
        let(:xml_response) { xml['multistatus']['response'] }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        # For an example response see https://github.com/csvalpha/amber-api/wiki/CardDAV-explained-with-examples
        it_behaves_like '207 Multistatus'
        it do
          expect(xml_response['href']).to eq(
            "/webdav/#{user.id}/#{user.webdav_secret_key}" \
            "/contacts/books/#{group.id}/#{group.users[0].id}"
          )
        end
        it { expect(xml_response['propstat']['prop']['displayname']).to eq group.users[0].id.to_s }
        it do
          expect(xml_response['propstat']['prop']['address_data'])
            .to eq(Webdav::Contact.user_to_vcard(group.users[0]).to_s)
        end
      end
    end
  end
end
