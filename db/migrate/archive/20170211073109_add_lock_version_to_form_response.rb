class AddLockVersionToFormResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :form_responses, :lock_version, :integer
  end
end
