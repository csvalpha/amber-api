class CreateCollection < ActiveRecord::Migration[5.0]
  def change
    create_table :debit_collections do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.references :author, references: :users
      t.datetime :deleted_at
      t.timestamps
    end

    create_table :debit_transactions do |t|
      t.references :user
      t.references :collection
      t.string :description
      t.decimal :amount, precision: 8, scale: 2
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
