require 'rails_helper'

RSpec.describe Import::SendActivateMail, type: :model do
  subject(:send_activation) { Import::SendActivateMail.new }

  let(:not_activated_user) { FactoryBot.create(:user, activated_at: nil) }
  let(:user_with_activation_token) do
    FactoryBot.create(:user, activated_at: nil,
                             activation_token: User.activation_token_hash)
  end
  let(:already_activated_user) { FactoryBot.create(:user, activated_at: Time.zone.now) }

  describe 'when sending activate mail' do
    before do
      ActionMailer::Base.deliveries = []
      not_activated_user
      user_with_activation_token
      already_activated_user
      send_activation.send!
    end

    let(:mail) { ActionMailer::Base.deliveries }

    it do # rubocop:disable RSpec/MultipleExpectations
      expect(mail.count).to eq 1
      expect(mail.first.to[0]).to eq not_activated_user.reload.email
      expect(not_activated_user.activation_token).not_to be nil
    end
  end

  describe '#print_users' do
    let(:result) { send_activation.print_users }

    before do
      not_activated_user
      user_with_activation_token
      already_activated_user
    end

    it { expect(result).to include not_activated_user.full_name }
    it { expect(result).to include not_activated_user.email }
    it { expect(result).not_to include user_with_activation_token.full_name }
    it { expect(result).not_to include already_activated_user.full_name }
  end
end
