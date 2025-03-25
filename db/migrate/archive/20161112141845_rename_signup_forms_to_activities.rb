class RenameSignupFormsToActivities < ActiveRecord::Migration[5.0]
  def change
    remove_index :signup_forms, name: :index_signup_forms_on_deleted_at, column: :deleted_at
    remove_index :signup_forms, name: :index_signup_forms_on_form_id, column: :form_id

    rename_table :signup_forms, :activities

    add_index :activities, :deleted_at
    add_index :activities, :form_id, unique: true
  end
end
