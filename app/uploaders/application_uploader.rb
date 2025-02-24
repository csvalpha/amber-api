class ApplicationUploader < CarrierWave::Uploader::Base
  include CarrierWave::BombShelter
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.pluralize.underscore}/#{model.id}/#{mounted_as}"
  end

  # See https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Create-random-and-unique-filenames-for-all-versioned-files#unique-filenames
  def filename
    "#{secure_token}.#{file.extension}"
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
