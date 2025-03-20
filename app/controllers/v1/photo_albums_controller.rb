class V1::PhotoAlbumsController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: %i[index show]
  before_action :set_model, only: %i[dropzone zip]

  def dropzone
    authorize @model

    if new_photo.save
      render json: new_photo, status: :created
    else
      render plain: new_photo.errors.messages[:image].first, status: unprocessable_entity
    end
  end

  def zip
    send_data @model.to_zip
  end

  private

  def new_photo
    @new_photo ||= Photo.new(
      image: params[:file],
      photo_album: @model,
      original_filename: params[:file].try(:original_filename),
      uploader: current_user
    )
  end
end
