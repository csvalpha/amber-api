require 'http'

# Minimal WebDAV client for uploading files to the Nextcloud account configured in
# config.x.nextcloud_* (an app password of a dedicated service account)
class NextcloudWebdav
  class Error < StandardError; end

  TIMEOUTS = { connect: 10, write: 60, read: 60 }.freeze # seconds

  def self.configured?
    config = Rails.application.config.x
    [config.nextcloud_url, config.nextcloud_declarations_user, config.nextcloud_declarations_password].all?(&:present?)
  end

  def self.from_config
    config = Rails.application.config.x
    new(url: config.nextcloud_url, user: config.nextcloud_declarations_user,
        password: config.nextcloud_declarations_password)
  end

  # Only HTTPS is accepted, the credentials are sent with every request
  def initialize(url:, user:, password:)
    raise ArgumentError, 'Nextcloud URL must use https' unless url.to_s.start_with?('https://')

    @url = url.chomp('/')
    @user = user
    @password = password
  end

  def upload(path, content)
    ensure_directories(File.dirname(path))
    request(:put, path, body: content)
  end

  def delete(path)
    request(:delete, path, allowed_codes: [404])
  end

  private

  # MKCOL every parent directory, 405 means it already exists
  def ensure_directories(directory)
    segments = segments(directory)
    segments.each_index do |index|
      request(:mkcol, segments[0..index].join('/'), allowed_codes: [405])
    end
  end

  def request(verb, path, body: nil, allowed_codes: [])
    response = HTTP.timeout(TIMEOUTS).basic_auth(user: @user, pass: @password).request(verb, url_for(path), body:)
    return response if response.status.success? || allowed_codes.include?(response.code)

    raise Error, "Nextcloud #{verb.upcase} #{path} failed with status #{response.code}"
  end

  def url_for(path)
    encoded_path = segments(path).map { |segment| ERB::Util.url_encode(segment) }.join('/')
    "#{@url}/remote.php/dav/files/#{ERB::Util.url_encode(@user)}/#{encoded_path}"
  end

  def segments(path)
    path.to_s.split('/').compact_blank - ['.']
  end
end
