require 'rails_helper'

describe MailgunController do
  describe 'POST /mailgun/bounced' do
    let(:record_url) { '/mailgun/bounces' }
    let(:event_data) do
      { message:
          { headers:
              { from: 'from@csvalpha.nl', to: 'to@csvalpha.nl', subject: 'Subject' } } }
    end
    let(:params) do
      {
        'event-data': event_data,
        signature: {
          timestamp: '1500991490',
          token: '3fc56c156c361d0e2edab9bb92ccdcb849a326f62b9d7bff62',
          signature: 'c602dcb495d0e3c5f48ef891a49aa630787bbf9427213ddb0f395569b53c5b19'
        }
      }
    end

    describe 'request from webhook' do
      let(:request) do
        post(record_url, params)
      end

      before { request }

      it_behaves_like '200 OK'
      it do
        expect(MailBouncedJob).to have_been_enqueued.with(event_data)
      end
    end
  end
end
