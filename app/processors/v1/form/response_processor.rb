class V1::Form::ResponseProcessor < JSONAPI::Authorization::AuthorizingProcessor
  define_jsonapi_resources_callbacks :recreate_resource
  set_callback :recreate_resource, :before, :authorize_create_resource

  def process
    return super unless operation_type == :create_resource

    model = Form::Response.only_deleted.find_by(model_fetch_keys)
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

  def model_fetch_keys
    { user: context[:user], form: params[:data][:to_one][:form] }
  end

  def recreate_resource
    resource_id = params[:resource_id]
    data = params[:data]

    resource = resource_klass.find_by_key(resource_id, context: context)

    result = resource.replace_fields(data)

    JSONAPI::ResourceOperationResult.new(result == :completed ? :created : :accepted, resource)
  end
end
