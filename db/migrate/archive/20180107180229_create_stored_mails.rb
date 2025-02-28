class CreateStoredMails < ActiveRecord::Migration[5.1]
  def change
    create_table :stored_mails do |t|
      t.datetime :deleted_at
      t.string :message_url
      t.string :sender
      t.references :mail_alias
      t.string :subject
      t.datetime :received_at
      t.timestamps
    end
  end
end
