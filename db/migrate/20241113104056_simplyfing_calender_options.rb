class SimplyfingCalenderOptions < ActiveRecord::Migration[7.0]
  def change
    Activity.where(category: 'dinsdagkring').update_all(category: 'kring') 
    Activity.where(category: 'woensdagkring').update_all(category: 'kring') 
  end
end
