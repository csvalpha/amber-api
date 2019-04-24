class DailyVerses < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_verses do |t|
      t.string :book, null: false
      t.integer :chapter, null: false
      t.integer :verse, null: false
      t.string :content, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
