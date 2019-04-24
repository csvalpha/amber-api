class RemoveRespectingFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :respecting
  end
end
