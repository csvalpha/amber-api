class AddOtpSecretKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :otp_secret_key, :string
    add_column :users, :otp_required, :boolean
  end
end
