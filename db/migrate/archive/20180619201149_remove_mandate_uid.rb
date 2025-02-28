class RemoveMandateUid < ActiveRecord::Migration[5.1]
  def change
    remove_column :debit_mandates, :uid
  end
end
