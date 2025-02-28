class AddNotificationModel < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :content_id
      t.string :content_type
      t.boolean :did_read, default: false, null: false
      t.references :user
      t.datetime :deleted_at
      t.timestamps
      t.index %i[user_id content_id]
    end
  end
end
