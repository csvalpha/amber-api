require 'rails_helper'

describe V1::StoredMailsController do
  describe 'POST /stored_mails/:id/accept', version: 1 do
    let(:request) { perform_enqueued_jobs(except: MailForwardJob) { post(record_url) } }
    let(:record) { FactoryBot.create(:stored_mail) }
    let(:record_url) { "/v1/stored_mails/#{record.id}/accept" }
    let(:record_permission) { 'stored_mail.destroy' }

    it_behaves_like 'a destroyable and permissible model' do
      let(:request) { perform_enqueued_jobs(only: ActionMailer::DeliveryJob) { post(record_url) } }
    end

    context 'sends accept mail' do
      let(:accept_mail) { ActionMailer::Base.deliveries.first }

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before do
        ActionMailer::Base.deliveries = []

        perform_enqueued_jobs do
          request
        end
      end

      it { expect(record.sender).to include accept_mail.to.first }
      it { expect(accept_mail.subject).to include 'Mail goedgekeurd' }
    end

    context 'does not send mail when already send today' do
      let(:accept_mail) { ActionMailer::Base.deliveries.first }

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: [record_permission]) }
      end

      before do
        ActionMailer::Base.deliveries = []

        allow(Rails.cache).to receive(:fetch).once.and_return(true)
        request
      end

      it_behaves_like '200 OK'

      it { expect(record.sender).to include accept_mail.to.first }
      it { expect(accept_mail.subject).to include 'Mail goedgekeurd' }
    end
  end
end
