class ConvertPaperTrailToJson < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :new_object, :jsonb
    add_column :versions, :new_object_changes, :jsonb

    PaperTrail::Version.find_each do |version|
      version.update_column(:new_object, YAML.unsafe_load(version.object)) if version.object # rubocop:disable Rails/SkipsModelValidations

      if version.object_changes
        version.update_column(:new_object_changes, YAML.unsafe_load(version.object_changes)) # rubocop:disable Rails/SkipsModelValidations
      end
    end

    remove_column :versions, :object
    remove_column :versions, :object_changes
    rename_column :versions, :new_object, :object
    rename_column :versions, :new_object_changes, :object_changes
  end
end
