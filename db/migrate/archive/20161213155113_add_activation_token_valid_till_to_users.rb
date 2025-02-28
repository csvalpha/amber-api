class AddActivationTokenValidTillToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :activation_token_valid_till, :datetime
  end
end
