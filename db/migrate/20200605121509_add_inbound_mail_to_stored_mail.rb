class AddInboundMailToStoredMail < ActiveRecord::Migration[6.0]
  def change
    add_reference :stored_mails, :inbound_email, references: ::ActionMailbox::InboundEmail, index: true
    add_foreign_key :stored_mails, ::ActionMailbox::InboundEmail, column: :inbound_email_id
  end
end
