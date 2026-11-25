class AddManualPaymentToDeclarations < ActiveRecord::Migration[7.2]
  def change
    change_table :declarations, bulk: true do |t|
      t.decimal :manually_paid_amount, precision: 8, scale: 2, null: false, default: 0
      t.datetime :manually_paid_at
      t.references :manually_paid_by, foreign_key: { to_table: :users, on_delete: :nullify }
    end
  end
end
