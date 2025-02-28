class CreateUsersAndGroupsMailAliases < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_aliases do |t|
      t.string :email
      t.string :moderation_type
      t.string :description
      t.integer :group_id
      t.integer :user_id

      t.timestamps
      t.datetime :deleted_at
      t.index :email, unique: true
    end
  end
end
