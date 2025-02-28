class AddOrderColumnStaticPages < ActiveRecord::Migration[5.0]
  def change
    add_column :static_pages, :position, :integer, null: false, default: 0
  end
end
