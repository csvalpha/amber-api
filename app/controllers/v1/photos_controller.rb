class V1::PhotosController < V1::ApplicationController
  # Logged out visitors can only see the photos on the overview page of a public photo album
  before_action :doorkeeper_authorize!, unless: :photo_album_overview?

  private

  def photo_album_overview?
    action_name == 'get_related_resources' && params[:source] == 'v1/photo_albums'
  end
end
