class ConvertPaperTrailToJson < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :new_object, :jsonb
    add_column :versions, :new_object_changes, :jsonb

    PaperTrail::Version.find_each do |version|
      if version.object
        version.update_column(:new_object, YAML.load(version.object))
      end

      if version.object_changes
        version.update_column(:new_object_changes, YAML.load(version.object_changes))
      end
    end

    remove_column :versions, :object
    remove_column :versions, :object_changes
    rename_column :versions, :new_object, :object
    rename_column :versions, :new_object_changes, :object_changes
  end
end
