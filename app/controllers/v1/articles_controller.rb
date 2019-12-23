class V1::ArticlesController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Article

    records = policy_scope(Article.all)
    render json: ArticlesSerializer.new(records, {params: {current_user: current_user}}).serialized_json
  end

  def show
    record = Article.find(params[:id])
    authorize record

    render json: ArticlesSerializer.new(record).serialized_json
  end

  def create
    authorize Article
    record = Article.new(data.merge(override_attributes))

    if record.save
      render json: ArticlesSerializer.new(record).serialized_json
    else
      respond_with_errors(record)
    end
  end

  def update
    record = Article.find(params[:id])
    authorize record

    if record.update(data)
      render json: ArticlesSerializer.new(record).serialized_json
    else
      respond_with_errors(record)
    end
  end

  def destroy
    record = Article.find(params[:id])
    authorize record

    if record.destroy
      head :no_content
    else
      render json: record.errors
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def data
    data = params[:data].permit({'attributes': permitted_create_attributes})
    for rel in permitted_relationships
      data["#{rel}_id"] = params[:data][:relationships][rel][:data][:id]
    end
    data
  end

  def permitted_create_attributes
    [:title, :content]
  end

  def permitted_relationships
    []
  end

  def respond_with_errors(object)
    render json: {errors:
                    object.errors.messages.flat_map do |field, errors|
                      errors.map do |error_message|
                        {
                          status: 422,
                          source: {
                            pointer: "/data/attributes/#{CaseTransform.dash(field)}"
                          },
                          detail: error_message
                        }
                      end
                    end
    }, status: :unprocessable_entity
  end

  def override_attributes
    {'author_id': @current_user.id}
  end
end
