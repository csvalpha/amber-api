class AddReferenceToDailyVerse < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_verses, :reference, :string
    DailyVerse.find_each do |daily_verse|
      reference = "#{daily_verse.book} #{daily_verse.chapter}:#{daily_verse.verse}"
      daily_verse.reference = reference
      daily_verse.save
    end
    remove_column :daily_verses, :book
    remove_column :daily_verses, :chapter
    remove_column :daily_verses, :verse
  end
end
