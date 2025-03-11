module CamoHelper
  # See https://github.com/ankane/camo/blob/master/lib/camo.rb
  def camo(image_url)
    hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'),
                                        Rails.application.config.x.camo_key, image_url)
    encoded_image_url = image_url.unpack1('H*')
    "#{Rails.application.config.x.camo_host}/#{hexdigest}/#{encoded_image_url}"
  end
end
