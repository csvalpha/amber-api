class AddUnvisitedThreads < ActiveRecord::Migration[6.0]
  def change
    create_table :unread_threads do |t|
      t.integer :user_id, index: true
      t.integer :thread_id, index: true
      t.integer :post_id

      t.timestamps
    end
  end
end
