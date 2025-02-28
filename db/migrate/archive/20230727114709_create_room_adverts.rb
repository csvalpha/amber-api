class CreateRoomAdverts < ActiveRecord::Migration[7.0]
  def change
    create_table :room_adverts do |t|
      t.string :house_name, null: false
      t.string :contact, null: false
      t.string :location
      t.string :available_from
      t.string :description, null: false
      t.string :cover_photo
      t.boolean :publicly_visible
      t.integer :author_id
      t.datetime :deleted_at

      t.timestamps
    end

    Permission.create(name: 'room_advert.create')
    Permission.create(name: 'room_advert.read')
    Permission.create(name: 'room_advert.update')
    Permission.create(name: 'room_advert.destroy')
  end
end
