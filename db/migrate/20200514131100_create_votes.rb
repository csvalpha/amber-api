class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :vote_forms do |t|
      t.string :question, null: false
      t.datetime :deleted_at
      t.references :author, references: :users, index: true

      t.timestamps
    end

    create_table :vote_responses do |t|
      t.references :form, index: true
      t.string :response, null: false

      t.timestamps
    end

    create_table :vote_respondents, id: false do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :form, index: true
      t.references :respondent, references: :users, index: true

      t.index %i[form_id respondent_id], unique: true
    end
  end
end
