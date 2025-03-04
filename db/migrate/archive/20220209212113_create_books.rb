class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author
      t.string :description
      t.string :isbn
      t.string :cover_photo

      t.timestamps
      t.datetime :deleted_at
      t.index :isbn, unique: true
    end
  end
end
