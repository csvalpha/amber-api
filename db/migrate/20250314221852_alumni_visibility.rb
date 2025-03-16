class AlumniVisibility < ActiveRecord::Migration[7.0]
  def up
    add_column :photo_albums, :visibility, :string, default: 'members', null: false

    PhotoAlbum.find_each do |record|
      record.update!(visibility: record.publicly_visible ? 'public' : 'members')
    end

    remove_column :photo_albums, :publicly_visible
  end

  def down
    add_column :photo_albums, :publicly_visible, :boolean, default: false, null: false

    PhotoAlbum.find_each do |record|
      record.update!(publicly_visible: record.visibility == 'public')
    end

    remove_column :photo_albums, :visibility
  end
end
