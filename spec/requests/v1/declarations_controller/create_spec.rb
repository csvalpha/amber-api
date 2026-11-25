require 'rails_helper'

describe V1::DeclarationsController do
  describe 'POST /declarations', version: 1 do
    let(:record_url) { '/v1/declarations' }
    let(:white_pixel) { 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+ip1sAAAAASUVORK5CYII=' }
    let(:attributes) do
      { amount: 12.5, description: 'Boodschappen borrel', purchase_date: Date.yesterday,
        receipt: "data:image/png;base64,#{white_pixel}" }
    end
    let(:request) { post(record_url, data: { type: 'declarations', attributes: }) }

    context 'when not authenticated' do
      it_behaves_like '401 Unauthorized'
      it { expect { request }.not_to(change(Declaration, :count)) }
    end

    context 'when authenticated' do
      include_context 'when authenticated'

      it_behaves_like '201 Created'
      it { expect { request }.to(change(Declaration, :count).by(1)) }

      it 'creates the declaration for the current user' do
        request
        expect(Declaration.last.user).to eq user
      end

      it 'stores the receipt outside of public' do
        request
        expect(Declaration.last.receipt.path).not_to include(Rails.public_path.to_s)
      end

      it { expect(request && Declaration.last).to be_pending }

      context 'when without receipt but with a reason' do
        let(:attributes) do
          { amount: 12.5, description: 'Boodschappen', purchase_date: Date.yesterday,
            missing_receipt_reason: 'Bon kwijtgeraakt' }
        end

        it_behaves_like '201 Created'
      end

      context 'when without receipt and without a reason' do
        let(:attributes) { { amount: 12.5, description: 'Boodschappen', purchase_date: Date.yesterday } }

        it_behaves_like '422 Unprocessable Content'
      end

      context 'when trying to set the status' do
        let(:attributes) { super().merge(status: 'approved') }

        it { expect(request && Declaration.last).to be_pending }
      end
    end
  end
end
