require 'rails_helper'

describe MailgunController do
  describe 'POST /mailgun' do
    let(:record_url) { '/mailgun' }
    let(:params) do
      {
        recipient: 'to@csvalpha.nl',
        timestamp: '1555615961',
        token: '1ae7062195ab8f7b0f35621e2639a5972fb6ce6867007c4d03',
        'message-url' => 'https://example.org'
      }
    end

    describe 'with correct signature' do
      let(:request) do
        post(record_url, params.merge(signature:
          'c52f12dcf46e86dcbbd551c8052c17c9d88920782ff37ec9f619aa8e095ba615'))
      end

      before { request }

      it_behaves_like '200 OK'
      it do
        expect(MailReceiveJob).to have_been_enqueued.with(
          params[:recipient], params['message-url']
        )
      end
    end

    describe 'with incorrect signature' do
      let(:request) { post(record_url, params.merge(signature: 'deadbeef')) }

      before { request }

      it_behaves_like '406 Not Acceptable'
      it { expect(MailReceiveJob).not_to have_been_enqueued }
    end
  end
end
