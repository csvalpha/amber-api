class StoredMailRemoveMailgun < ActiveRecord::Migration[6.1]
  def change
    remove_column :stored_mails, :message_url
    remove_column :stored_mails, :sender
    remove_column :stored_mails, :subject

    remove_foreign_key :stored_mails, ::ActionMailbox::InboundEmail, column: :inbound_email_id
    add_foreign_key :stored_mails, ::ActionMailbox::InboundEmail, column: :inbound_email_id,
                                                                  on_delete: :cascade
  end
end
