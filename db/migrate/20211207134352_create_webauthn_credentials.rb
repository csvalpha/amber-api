class CreateWebauthnCredentials < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :webauthn_id, :string

    create_table :webauthn_credentials do |t|
      t.string :nickname
      t.string :external_id, null: false, index: { unique: true }
      t.string :public_key, null: false
      t.bigint :sign_count, null: false, default: 0

      t.references :user, foreign_key: true, null: false

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :webauthn_challenges do |t|
      t.string :challenge, null: false, index: { unique: true }
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
