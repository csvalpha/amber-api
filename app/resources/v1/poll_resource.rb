class V1::PollResource < V1::ApplicationResource
  has_one :form, class_name: 'Form::Form', always_include_linkage_data: true
  has_one :author, class_name: 'User'

  before_create do
    @model.author_id = current_user.id
  end

  def self.creatable_fields(_context)
    %i[form]
  end

  def self.search(records, value)
    return records if records == []

    records.joins(form: :closed_questions).where('form_closed_questions.question ILIKE ?',
                                                 "%#{value.first}%")
  end
end
