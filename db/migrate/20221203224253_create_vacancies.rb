class CreateVacancies < ActiveRecord::Migration[6.1]
  def change
    create_table :vacancies do |t|
      t.string :title, null: false
      t.string :description
      t.string :workload
      t.string :workload_peak
      t.string :cover_photo
      t.string :contact
      t.date :deadline
      t.integer :author_id, null: false
      t.integer :group_id

      t.timestamps
      t.datetime :deleted_at
    end

    Permission.create(name: 'vacancy.create')
    Permission.create(name: 'vacancy.read')
    Permission.create(name: 'vacancy.update')
    Permission.create(name: 'vacancy.destroy')
  end
end
