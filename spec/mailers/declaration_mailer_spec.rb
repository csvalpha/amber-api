require 'rails_helper'

RSpec.describe DeclarationMailer do
  let(:declaration) { create(:declaration, :approved, description: 'Boodschappen') }

  describe '#approved_email' do
    let(:mail) { described_class.approved_email(declaration) }

    it { expect(mail.to).to eq [declaration.user.email] }
    it { expect(mail.subject).to eq 'Declaratie goedgekeurd: Boodschappen' }
    it { expect(mail.body.encoded).to include declaration.approved_by.full_name }
  end

  describe '#rejected_email' do
    let(:declaration) { create(:declaration, :rejected, description: 'Boodschappen', rejection_reason: 'Geen bon') }
    let(:mail) { described_class.rejected_email(declaration) }

    it { expect(mail.subject).to eq 'Declaratie afgekeurd: Boodschappen' }
    it { expect(mail.body.encoded).to include 'Geen bon' }
  end

  describe '#deleted_email' do
    let(:questor) { create(:user) }
    let(:mail) { described_class.deleted_email(declaration.user, 'Boodschappen', 12.5, questor) }

    it { expect(mail.to).to eq [declaration.user.email] }
    it { expect(mail.subject).to eq 'Declaratie verwijderd: Boodschappen' }
    it { expect(mail.body.encoded).to include questor.full_name }
  end
end
