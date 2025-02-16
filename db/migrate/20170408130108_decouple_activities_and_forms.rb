class DecoupleActivitiesAndForms < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :title, :string
    add_column :activities, :description, :string
    add_column :activities, :author_id, :integer
    add_column :activities, :group_id, :integer

    migrate_data_from_form_to_activities

    remove_column :form_forms, :title, :string
    remove_column :form_forms, :description, :string
    change_column :activities, :form_id, :integer, null: true
  end

  def migrate_data_from_form_to_activities
    Form::Form.find_each do |form|
      activity = Activity.find_by(form:)
      next unless activity

      activity.assign_attributes(title: form.title, description: form.description,
                                 author_id: form.author_id, group_id: form.group_id)
      activity.save(validate: false)
    end
  end
end
