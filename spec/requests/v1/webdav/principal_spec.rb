require 'rails_helper'

# rubocop:disable DescribeClass
describe 'DAV4Rack::Carddav::Controller for DAV4Rack::Carddav::PrincipalResource' do
  # rubocop:enable DescribeClass
  describe 'PROPFIND /webdav/:user_id/:key/contacts', version: 1 do
    let(:user) do
      FactoryBot.create(:user, :webdav_enabled, activated_at: Time.zone.now)
    end

    context 'when requesting resourcetype and current-user-principal' do
      let(:request_data) do
        '<?xml version="1.0" encoding="utf-8" ?>
         <A:propfind xmlns:A="DAV:">
            <A:prop><A:resourcetype/><A:current-user-principal/></A:prop>
         </A:propfind>'
      end

      context 'when with valid secret' do
        let(:request_url) { "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts" }
        let(:xml) { Hash.from_xml(request.body) }
        let(:xml_response) { xml['multistatus']['response'] }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        # For an example response see https://github.com/csvalpha/amber-api/wiki/CardDAV-explained-with-examples
        it_behaves_like '207 Multistatus'
        it do
          expect(xml_response['propstat']['prop']['resourcetype'].keys)
            .to contain_exactly('collection', 'principal')
        end
        it do
          expect(xml_response['propstat']['prop']['current_user_principal']['href'])
            .to eq "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts"
        end
      end
    end

    context 'when requesting addressbook-home-set' do
      let(:request_data) do
        '<?xml version="1.0" encoding="utf-8" ?>
         <A:propfind xmlns:A="DAV:" xmlns:B="urn:ietf:params:xml:ns:carddav">
            <A:prop><B:addressbook-home-set/></A:prop>
         </A:propfind>'
      end

      context 'when with valid secret' do
        let(:request_url) { "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/" }
        let(:xml) { Hash.from_xml(request.body) }
        let(:xml_response) { xml['multistatus']['response'] }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        # For an example response see https://github.com/csvalpha/amber-api/wiki/CardDAV-explained-with-examples
        it_behaves_like '207 Multistatus'
        it do
          expect(xml_response['propstat']['prop']['addressbook_home_set']['href'])
            .to eq "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/"
        end
      end
    end
  end
end
