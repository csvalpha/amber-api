class AddDefaultsToBooleanFieldsToDatabase < ActiveRecord::Migration[5.0]
  def change
    change_column :articles, :publicly_visible, :boolean, null: false, default: false
    change_column :form_closed_questions, :required, :boolean, null: false, default: false
    change_column :form_open_questions, :required, :boolean, null: false, default: false
    change_column :users, :enabled, :boolean, null: false, default: false
  end
end
