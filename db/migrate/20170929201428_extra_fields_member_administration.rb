class ExtraFieldsMemberAdministration < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :emergency_contact, :string
    add_column :users, :emergency_number, :string
    add_column :users, :ifes_data_sharing_preference, :boolean, default: false, null: false
    add_column :users, :info_in_almanak, :boolean, default: false, null: false
    add_column :users, :almanak_subscription_preference, :integer, default: 0
    add_column :users, :digtus_subscription_preference, :integer, default: 0
  end
end
