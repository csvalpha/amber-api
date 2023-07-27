class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :house_name, null: false
      t.string :location
      t.string :contact, null: false
      t.string :description, null: false
      t.string :cover_photo
      t.boolean :publicly_visible
      t.integer :author_id
      t.datetime :deleted_at

      t.timestamps
    end

    Permission.create(name: 'room.create')
    Permission.create(name: 'room.read')
    Permission.create(name: 'room.update')
    Permission.create(name: 'room.destroy')
  end
end
