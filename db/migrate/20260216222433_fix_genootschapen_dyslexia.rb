class FixGenootschapenDyslexia < ActiveRecord::Migration[7.2]
  def up
    Activity.where(category: 'genootschapen').find_each do |activity|
      activity.update!(category: 'genootschappen')
    end
  end

  def down
    Activity.where(category: 'genootschappen').find_each do |activity|
      activity.update!(category: 'genootschapen')
    end
  end
end
