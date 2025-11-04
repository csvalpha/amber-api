require 'rails_helper'

describe V1::StoredMailsController do
  describe 'POST /stored_mails/:id/accept', version: 1 do
    let(:request) { post(record_url) }
    let(:record) { create(:stored_mail) }
    let(:record_url) { "/v1/stored_mails/#{record.id}/accept" }
    let(:record_permission) { 'stored_mail.destroy' }

    it_behaves_like 'a destroyable and permissible model' do
      let(:request) do
        perform_enqueued_jobs(only: ActionMailer::MailDeliveryJob) do
          post(record_url)
        end
      end
    end

    context 'sends accept mail' do
      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before do
        allow(Rails.cache).to receive(:write)
      end

      it_behaves_like '204 No Content'
      it { expect { request }.to have_enqueued_job(MailForwardJob) }
      it { expect { request }.to have_enqueued_job(ActionMailer::MailDeliveryJob) }

      describe 'Mail is send' do
        before do
          perform_enqueued_jobs do
            request
          end
        end

        let(:accept_mail) { ActionMailer::Base.deliveries.first }

        it { expect(accept_mail.subject).to include 'Mail goedgekeurd' }
      end
    end

    context 'does not send mail when already sent today' do
      let(:accept_mail) { ActionMailer::Base.deliveries.first }

      include_context 'when authenticated' do
        let(:user) { create(:user, user_permission_list: [record_permission]) }
      end

      before do
        allow(Rails.cache).to receive(:exist?).once.and_return(true)
      end

      it_behaves_like '422 Unprocessable Content'
      it { expect { request }.not_to have_enqueued_job(MailForwardJob) }
    end
  end
end
