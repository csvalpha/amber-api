class RemoveQuickpost < ActiveRecord::Migration[7.0]
  def change
    def up
      drop_table :quickpost_messages
    end
  
    def down
      raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted because it destroys data."
    end
  end
end
