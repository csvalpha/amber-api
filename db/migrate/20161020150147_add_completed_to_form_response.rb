class AddCompletedToFormResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :form_responses, :completed, :boolean, null: false, default: false
  end
end
