class RemoveTotalAmountFromCollection < ActiveRecord::Migration[5.1]
  def change
    remove_column :debit_collections, :total_amount
    remove_column :debit_collections, :lock_version
  end
end
