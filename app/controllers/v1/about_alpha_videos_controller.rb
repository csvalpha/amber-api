require 'net/http'

class V1::AboutAlphaVideosController < V1::ApplicationController
  include CamoHelper

  before_action :doorkeeper_authorize!, except: [:index]

  def index
    data = Rails.cache.fetch('about_alpha', expires_in: ttl_to_midnight) do
      parse_playlist(retrieve_playlist)
    end
    render json: data
  end

  def retrieve_playlist # rubocop:disable Metrics/MethodLength
    uri = URI.parse('https://www.googleapis.com/youtube/v3/playlistItems')
    params = {
      playlistId: 'PLsNvPioUtgdtEGxrWYBLMgg6iI1cqKv8l',
      key: Rails.application.config.x.youtube_api_key,
      maxResults: 10,
      part: 'snippet'
    }
    uri.query = URI.encode_www_form(params)
    request = Net::HTTP::Get.new(uri.request_uri, 'Content-Type' => 'application/json')
    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = true
    JSON.parse(client.request(request).body)
  end

  def parse_playlist(response) # rubocop:disable Metrics/AbcSize
    data = response['items'].map do |item|
      id = item['snippet']['position'] + 1
      video_id = ActionView::Base.full_sanitizer.sanitize(item['snippet']['resourceId']['videoId'])
      title = ActionView::Base.full_sanitizer.sanitize(item['snippet']['title'])
      thumbnail_url = camo(item['snippet']['thumbnails']['maxres']['url'])
      { 'id': id, 'type': 'about_alpha_videos', 'attributes':
          { 'video_id': video_id, 'title': title, 'thumbnail_url': thumbnail_url } }
    end

    { data: data }
  end

  def ttl_to_midnight
    24.hours.seconds - Time.zone.now.seconds_since_midnight
  end
end
