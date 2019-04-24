class V1::Form::ClosedQuestionAnswerProcessor < JSONAPI::Authorization::AuthorizingProcessor
  define_jsonapi_resources_callbacks :recreate_resource
  set_callback :recreate_resource, :before, :authorize_create_resource

  def process
    return super unless operation_type == :create_resource

    model = Form::ClosedQuestionAnswer.only_deleted.find_by(model_fetch_keys)
    return super unless model

    # Model you try to create already exists but is deleted
    # To prevent primary key errors we first restore the old object
    # and then update that record to match the new state
    model.restore
    params[:resource_id] = model.id
    run_callbacks :recreate_resource do
      return recreate_resource
    end
  end

  def model_fetch_keys # rubocop:disable Metrics/AbcSize
    if params[:data][:to_one][:option]
      question = Form::ClosedQuestionOption.find(params[:data][:to_one][:option]).question

      if question.radio_question?
        # radio question answers are unique per question,
        # thus when re-answering a radio question, the belonging answer must be restored
        return { response_id: params[:data][:to_one][:response], question_id: question.id }
      end
    end

    # checkbox question answers are not unique per question,
    # thus when giving a destroyed answer, that must be restored
    { response_id: params[:data][:to_one][:response], option_id: params[:data][:to_one][:option] }
  end

  def recreate_resource
    resource_id = params[:resource_id]
    data = params[:data]

    # rubocop:disable Rails/DynamicFindBy
    resource = resource_klass.find_by_key(resource_id, context: context)
    # rubocop:enable Rails/DynamicFindBy

    result = resource.replace_fields(data)

    JSONAPI::ResourceOperationResult.new(result == :completed ? :created : :accepted, resource)
  end
end
