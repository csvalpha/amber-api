class AddClosedAtToForumThread < ActiveRecord::Migration[5.0]
  def change
    add_column :forum_threads, :closed_at, :datetime
  end
end
