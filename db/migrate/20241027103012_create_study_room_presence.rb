class CreateStudyRoomPresence < ActiveRecord::Migration[7.0]
  def change
    create_table :study_room_presences do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.text :status, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end

  Permission.create(name: 'study_room_presence.create')
  Permission.create(name: 'study_room_presence.read')
  Permission.create(name: 'study_room_presence.update')
  Permission.create(name: 'study_room_presence.destroy')
end
