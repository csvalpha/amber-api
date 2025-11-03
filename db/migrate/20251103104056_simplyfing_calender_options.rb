class SimplyfingCalenderOptions < ActiveRecord::Migration[7.2]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    add_column :users, :ical_categories, :string, array: true, default: []
    Activity.where(category: 'dinsdagkring').update_all(category: 'kring')
    Activity.where(category: 'woensdagkring').update_all(category: 'kring')
    Activity.where(category: 'kiemgroepen').update_all(category: 'algemeen')
    Activity.where(category: 'curiositates').update_all(category: 'algemeen')
  end

  def down
    remove_column :users, :ical_categories
    Activity.where(category: 'kring').update_all(category: 'dinsdagkring')
    # NOTE: As mentioned before, reverting 'algemeen' to 'kiemgroepen' or 'curiositates'
    # cannot be done reliably with `update_all` without additional information.
    # The `down` migration here only addresses the 'kring' category.
  end
  # rubocop:enable Rails/SkipsModelValidations
end
