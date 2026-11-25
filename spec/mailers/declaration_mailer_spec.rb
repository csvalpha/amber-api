require 'rails_helper'

RSpec.describe DeclarationMailer do
  let(:declaration) { create(:declaration, :approved, description: 'Boodschappen') }

  # Compare against the rendered text, names with an apostrophe are HTML escaped in the body
  def body_text(mail)
    Nokogiri::HTML(mail.body.decoded).text.squish
  end

  describe '#approved_email' do
    let(:mail) { described_class.approved_email(declaration) }

    it { expect(mail.to).to eq [declaration.user.email] }
    it { expect(mail.subject).to eq 'Declaratie goedgekeurd: Boodschappen' }
    it { expect(body_text(mail)).to include declaration.approved_by.full_name }

    context 'when the approver has an apostrophe in their name' do
      let(:declaration) do
        create(:declaration, :approved, approved_by: create(:user, first_name: 'Jan', last_name_prefix: nil,
                                                                   last_name: "D'Artagnan"))
      end

      it { expect(body_text(mail)).to include "Jan D'Artagnan" }
    end
  end

  describe '#rejected_email' do
    let(:declaration) { create(:declaration, :rejected, description: 'Boodschappen', rejection_reason: 'Geen bon') }
    let(:mail) { described_class.rejected_email(declaration) }

    it { expect(mail.subject).to eq 'Declaratie afgekeurd: Boodschappen' }
    it { expect(body_text(mail)).to include 'Geen bon' }
  end

  describe '#deleted_email' do
    let(:questor) { create(:user) }
    let(:mail) { described_class.deleted_email(declaration.user, 'Boodschappen', 12.5, questor) }

    it { expect(mail.to).to eq [declaration.user.email] }
    it { expect(mail.subject).to eq 'Declaratie verwijderd: Boodschappen' }
    it { expect(body_text(mail)).to include questor.full_name }
  end
end
