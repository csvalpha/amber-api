class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|
      t.datetime :deleted_at

      t.timestamps
    end
    add_reference :polls, :author, index: true
    add_reference :polls, :form, index: true
  end
end
