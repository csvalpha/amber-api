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

    Permission.find_or_create_by!(name: 'study_room_presence.create')
    Permission.find_or_create_by!(name: 'study_room_presence.read')
    Permission.find_or_create_by!(name: 'study_room_presence.update')
    Permission.find_or_create_by!(name: 'study_room_presence.destroy')
  end
end
