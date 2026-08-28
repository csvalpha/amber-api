class CreateAlumniContributions < ActiveRecord::Migration[7.0]
  def change
    create_table :alumni_contributions do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.decimal :sponsoring_amount, precision: 10, scale: 2, default: 0.00
      t.boolean :help_digtus, default: false, null: false
      t.boolean :help_kring, default: false, null: false
      t.boolean :help_vereniging, default: false, null: false
      t.text :help_anders
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
