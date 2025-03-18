class RemoveUniqueIndexFromFormResponses < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        remove_index :form_responses, name: 'index_form_responses_on_form_id_and_user_id'

        add_index :form_responses, %i[form_id user_id],
                  unique: true,
                  name: 'index_form_responses_on_form_id_and_user_id_partial',
                  where: 'user_id != 0'
      end

      dir.down do
        remove_index :form_responses, name: 'index_form_responses_on_form_id_and_user_id_partial'

        add_index :form_responses, %i[form_id user_id],
                  unique: true,
                  name: 'index_form_responses_on_form_id_and_user_id'
      end
    end
  end
end
