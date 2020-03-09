class UnreadThreads < ActiveRecord::Migration[6.0]
  def change
    create_table :forum_unread_threads do |t|
      t.integer :user_id, index: true
      t.integer :thread_id, index: true
      t.integer :post_id

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
