class CreateDeclarations < ActiveRecord::Migration[7.2]
  def change
    create_declarations
    add_reference :debit_transactions, :declaration, foreign_key: true
    add_column :debit_collections, :finalized_at, :datetime

    reversible do |dir|
      dir.up { create_permissions }
    end
  end

  private

  def create_declarations
    create_table :declarations do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :description, null: false
      t.date :purchase_date, null: false
      t.string :receipt
      t.text :missing_receipt_reason
      t.string :status, null: false, default: 'pending', index: true
      t.text :rejection_reason
      t.boolean :include_in_next_collection, null: false, default: false
      t.references :approved_by, foreign_key: { to_table: :users, on_delete: :nullify }
      t.datetime :approved_at
      t.string :pdf_path
      t.datetime :pdf_uploaded_at
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def create_permissions
    %w[create read update destroy].each do |action|
      Permission.find_or_create_by!(name: "declaration.#{action}")
    end
  end
end
