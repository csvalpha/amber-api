class RemoveUniqueMembershipConstraint < ActiveRecord::Migration[5.0]
  def change
    remove_index :memberships, %i[group_id user_id]
    add_index :memberships, %i[group_id user_id start_date], unique: true
  end
end
