class SimplyfingCalenderOptions < ActiveRecord::Migration[7.0]
  def up
    Activity.where(category: 'dinsdagkring').find_each do |activity|
      activity.update(category: 'kring')
    end

    Activity.where(category: 'woensdagkring').find_each do |activity|
      activity.update(category: 'kring')
    end
  end

  def down
    Activity.where(category: 'kring').find_each do |activity|
      activity.update(category: 'dinsdagkring')
    end
  end
end
