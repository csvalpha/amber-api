class AddSmtpEnabled < ActiveRecord::Migration[5.2]
  def change
    add_column :mail_aliases, :smtp_enabled, :boolean, default: false, null: false
  end
end
