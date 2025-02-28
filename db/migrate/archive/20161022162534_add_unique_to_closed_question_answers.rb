class AddUniqueToClosedQuestionAnswers < ActiveRecord::Migration[5.0]
  def change
    change_table :form_closed_question_answers do |t|
      t.integer :question_id
      t.boolean :radio_question, null: false, default: false
      t.index %i[question_id response_id],
              unique: true, where: 'radio_question IS TRUE',
              name: 'index_form_closed_question_answers_on_question_and_response'
    end
  end
end
