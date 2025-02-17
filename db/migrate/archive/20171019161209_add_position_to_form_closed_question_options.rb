class AddPositionToFormClosedQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :form_closed_question_options, :position, :integer, default: 0
  end
end
