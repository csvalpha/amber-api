class AddModeratorToMailAliases < ActiveRecord::Migration[5.1]
  def change
    add_reference :mail_aliases, :moderator_group, references: :groups, index: true
    add_foreign_key :mail_aliases, :groups, column: :moderator_group_id
  end
end
