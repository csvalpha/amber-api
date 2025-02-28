class AddIcalSecretKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ical_secret_key, :string
    reversible do |dir|
      dir.up { generate_ical_secret_key }
    end
  end

  def generate_ical_secret_key
    User.all.map do |user|
      user.__send__(:generate_ical_secret_key)
      user.save
    end
  end
end
