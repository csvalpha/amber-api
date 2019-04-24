class RemoveDailyVerses < ActiveRecord::Migration[5.1]
  def change
    drop_table :daily_verses
    Permission.find_by(name: 'daily_verse.create')&.destroy
    Permission.find_by(name: 'daily_verse.read')&.destroy
    Permission.find_by(name: 'daily_verse.update')&.destroy
    Permission.find_by(name: 'daily_verse.destroy')&.destroy
  end
end
