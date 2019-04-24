class CreatePhotoCommentsAndAddCounterToPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_comments do |t|
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
    add_reference :photo_comments, :user, index: true
    add_reference :photo_comments, :photo, index: true
    add_column :photos, :comments_count, :integer, null: false, default: 0
  end
end
