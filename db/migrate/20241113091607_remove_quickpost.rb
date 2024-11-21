class RemoveQuickpost < ActiveRecord::Migration[7.0]
  def change
    drop_table :quickpost_messages

    Permission.find_by(name: 'quickpost_message.create')&.destroy
    Permission.find_by(name: 'quickpost_message.read')&.destroy
    Permission.find_by(name: 'quickpost_message.update')&.destroy
    Permission.find_by(name: 'quickpost_message.destroy')&.destroy
  end
end
