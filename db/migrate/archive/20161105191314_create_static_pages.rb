class CreateStaticPages < ActiveRecord::Migration[5.0]
  def change
    create_table :static_pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :content, null: false
      t.boolean :publicly_visible
      t.datetime :deleted_at

      t.timestamps

      t.index :slug, unique: true
    end
  end
end
