class RenameGroupHidden < ActiveRecord::Migration[5.1]
  def change
    rename_column :groups, :hidden, :administrative
  end
end
