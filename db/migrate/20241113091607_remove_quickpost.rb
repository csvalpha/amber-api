class RemoveQuickpost < ActiveRecord::Migration[7.0]
  def change
    drop_table :quickpost_messages
  end  
end
