class V1::Vote::ResponseProcessor < JSONAPI::Authorization::AuthorizingProcessor
  def process
    return super unless operation_type == :create_resource

    keys = model_fetch_keys
    respondent = Vote::Respondent.find_by(keys)

    if respondent
      # User has already responded, so return an error
      user = keys[:respondent].id
      form = keys[:form_id]
      errors = [JSONAPI::Error.new(code: JSONAPI::VALIDATION_ERROR,
                                   status: :bad_request,
                                   title: 'user already responded',
                                   detail: "user #{user} already responded to form #{form}.")]
      JSONAPI::ErrorsOperationResult.new(errors[0].code, errors)
    else
      Vote::Respondent.new(keys).save
      super
    end
  end

  def model_fetch_keys
    { respondent: context[:user], form_id: params[:data][:to_one][:form] }
  end
end
