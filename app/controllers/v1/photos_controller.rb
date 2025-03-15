class V1::PhotosController < V1::ApplicationController
  before_action do
    doorkeeper_authorize! unless %w[index show].include?(action_name) ||
                                 (action_name == 'get_related_resources' &&
                                  params[:source] == 'v1/photo_albums')
  end
end
