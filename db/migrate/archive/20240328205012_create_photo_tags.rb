class CreatePhotoTags < ActiveRecord::Migration[7.0]
  def change
    create_table :photo_tags do |t|
      t.decimal :x, precision: 5, scale: 2
      t.float :y, precision: 5, scale: 2
      t.integer :author_id, null: false
      t.integer :tagged_user_id, null: false
      t.integer :photo_id, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_column :photos, :tags_count, :integer, null: false, default: 0
  end

  Permission.create(name: 'photo_tag.create')
  Permission.create(name: 'photo_tag.read')
  Permission.create(name: 'photo_tag.update')
  Permission.create(name: 'photo_tag.destroy')
end
