require 'rails_helper'

describe 'DAV4Rack::Carddav::Controller for DAV4Rack::Carddav::AddressbookResource' do
  describe 'PROPFIND /webdav/:user_id/:key/contacts/books/:group_id', version: 1 do
    let(:users) { create_list(:user, 4, :webdav_enabled, activated_at: Time.zone.now) }
    let(:user) { users.first }
    let(:group) { create(:group, users:) }
    let(:not_member_group) do
      create(:group, users: create_list(:user, 3))
    end

    before { group && not_member_group }

    context 'when requesting props' do
      let(:request_data) do
        '<B:propfind xmlns:A="http://calendarserver.org/ns/" xmlns:B="DAV:">
          <B:prop>
            <B:supported-report-set/>
            <B:displayname/>
            <B:current-user-privilege-set/>
            <A:getctag/>
            <B:sync-token/>
          </B:prop>
        </B:propfind>'
      end

      context 'when with invalid secret' do
        let(:request_url) { "/webdav/#{user.id}/invalidsecret/contacts/books/#{group.id}" }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        it_behaves_like '404 Not Found'
      end

      context 'when with valid secret' do
        let(:request_url) do
          "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{group.id}"
        end
        let(:xml) { Hash.from_xml(request.body) }
        let(:responses) { xml['multistatus']['response'] }

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        # For an example response see https://github.com/csvalpha/amber-api/wiki/CardDAV-explained-with-examples
        it_behaves_like '207 Multistatus'
        it { expect(responses.length).to eq 5 }

        it do
          expect(responses[0]['href'])
            .to eq "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{group.id}/"
        end

        it { expect(responses[0]['propstat']['prop']['displayname']).to eq group.name }

        it 'contains responses for the contacts' do
          expect(responses[1..4].map { |r| r['href'] })
            .to match_array(group.users.map do |u|
              "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{group.id}/#{u.id}"
            end)
        end
      end

      context 'when requesting non member group' do
        let(:request_url) do
          "/webdav/#{user.id}/#{user.webdav_secret_key}/contacts/books/#{not_member_group.id}"
        end

        subject(:request) do
          current_session.request(request_url, method: 'PROPFIND', params: request_data)
        end

        it_behaves_like '404 Not Found'
      end
    end
  end
end
