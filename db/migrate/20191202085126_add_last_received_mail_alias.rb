class AddLastReceivedMailAlias < ActiveRecord::Migration[5.2]
  def change
    add_column :mail_aliases, :last_received_at, :datetime
  end
end
