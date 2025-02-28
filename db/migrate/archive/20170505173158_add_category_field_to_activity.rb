class AddCategoryFieldToActivity < ActiveRecord::Migration[5.0]
  def up
    add_column :activities, :category, :string
    execute <<-SQL.squish
      UPDATE activities SET category='algemeen'
    SQL
    change_column_null :activities, :category, false
  end
end
