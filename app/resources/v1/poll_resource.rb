# frozen_string_literal: true

class V1::PollResource < V1::ApplicationResource
  self.model = Poll

  with_timestamps

  has_one :form, resource: V1::Form::FormResource
  has_one :author, resource: V1::UserResource

  filter :search, :string do
    eq do |scope, value|
      scope.joins(form: :closed_questions).where('form_closed_questions.question ILIKE ?', "%#{value}%")
    end
  end

  before_save only: [:create] do |model|
    model.author_id = current_user.id
  end
end
