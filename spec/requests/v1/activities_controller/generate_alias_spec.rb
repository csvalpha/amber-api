require 'rails_helper'

describe V1::ActivitiesController do
  describe 'POST /activities/:id/generate_alias', version: 1 do
    subject(:request) { post(record_url) }

    context 'when unauthenticated' do
      let(:record) { create(:activity, :with_form) }
      let(:record_url) { "/v1/activities/#{record.id}/generate_alias" }

      it_behaves_like '401 Unauthorized'
    end

    context 'when authenticated' do
      include_context 'when authenticated' do
        let(:user) { create(:user) }
      end

      let(:record) { create(:activity, :with_form) }
      let(:responses) { create(:response, form: activity.form, completed: true) }
      let(:record_url) { "/v1/activities/#{record.id}/generate_alias" }

      it_behaves_like '403 Forbidden'

      context 'when with activity without form' do
        let(:record) { create(:activity, author: user) }

        before { request }

        it_behaves_like '422 Unprocessable Entity'
        it { expect(MailAliasCreateJob).not_to(have_been_enqueued) }
      end

      context 'when with activity user authored' do
        let(:record) { create(:activity, :with_form, author: user) }

        before { request }

        it_behaves_like '200 OK'
        it { expect(MailAliasCreateJob).to have_been_enqueued }
        it { expect(MailAliasDestroyJob).to have_been_enqueued }
      end

      context 'when with activity in group that user belongs to' do
        let(:group) { create(:group, users: [user]) }
        let(:record) { create(:activity, :with_form, group: group) }
        let(:record_url) { "/v1/activities/#{record.id}/generate_alias" }

        before { request }

        it_behaves_like '200 OK'
        it { expect(MailAliasCreateJob).to have_been_enqueued }
        it { expect(MailAliasDestroyJob).to have_been_enqueued }
      end
    end
  end
end
