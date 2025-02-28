class AddMandateModel < ActiveRecord::Migration[5.1]
  def up # rubocop:disable Metrics/AbcSize
    create_table :debit_mandates do |t|
      t.integer :uid, null: false
      t.string :iban, null: false
      t.string :iban_holder, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.references :user, references: :users
      t.datetime :deleted_at
      t.timestamps
      t.index :uid, unique: true
    end

    User.all.each do |user|
      Debit::Mandate.create(user:, uid: user.id,
                            iban: user.iban,
                            iban_holder: user.iban_holder,
                            start_date: Time.zone.now)
    end

    remove_column :users, :iban
    remove_column :users, :iban_holder
  end

  def down
    add_column :users, :iban, :string
    add_column :users, :iban_holder, :string
    drop_table :debit_mandates
  end
end
