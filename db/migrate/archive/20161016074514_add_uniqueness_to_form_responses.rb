class AddUniquenessToFormResponses < ActiveRecord::Migration[5.0]
  def change
    change_table :form_responses do |t|
      t.index %i[form_id user_id], unique: true
    end
    change_table :form_open_question_answers do |t|
      t.index %i[response_id question_id], unique: true
    end
    change_table :form_closed_question_answers do |t|
      t.index %i[response_id option_id], unique: true
    end
  end
end
