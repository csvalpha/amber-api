require 'net/http'

class V1::DailyVersesController < V1::ApplicationController
  before_action :doorkeeper_authorize!, except: [:index]

  def index
    data = Rails.cache.fetch('daily_verse', expires_in: ttl_to_midnight) do
      parse_verse(retrieve_verse)
    end
    render json: data
  end

  def retrieve_verse # rubocop:disable Metrics/AbcSize
    uri = URI.parse('http://feed.dagelijkswoord.nl/api/json/1.0/')
    request = Net::HTTP::Get.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.basic_auth(Rails.application.config.x.daily_verse_user,
                       Rails.application.config.x.daily_verse_password)
    JSON.parse(Net::HTTP.new(uri.host, uri.port).request(request).body)
  end

  def parse_verse(response)
    data = response['data'][0]
    copyright = ActionView::Base.full_sanitizer.sanitize(response['copyrights']['bgt'])
    reference = ActionView::Base.full_sanitizer.sanitize(data['source'])
    content = ActionView::Base.full_sanitizer.sanitize(data['text']['bgt'])
    { data: [{ 'id': 1, 'type': 'daily_verse', 'attributes':
      { 'copyright': copyright, 'reference': reference, 'content': content } }] }
  end

  def ttl_to_midnight
    24.hours.seconds - Time.zone.now.seconds_since_midnight
  end
end
