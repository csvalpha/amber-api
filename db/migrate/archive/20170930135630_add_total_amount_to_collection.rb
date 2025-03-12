class AddTotalAmountToCollection < ActiveRecord::Migration[5.1]
  def change
    add_column :debit_collections, :total_amount, :decimal, precision: 8, scale: 2
    add_column :debit_collections, :lock_version, :integer
  end
end
