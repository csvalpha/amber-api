module UploaderExtensions
  def cache_dir
    Rails.root.join('spec', 'support', 'uploads', 'tmp')
  end

  def store_dir
    if self.class == ApplicationUploader
      Rails.root.join('spec', 'support', super)
    else
      super
    end
  end
end

if Rails.env.test?
  Dir[Rails.root.join('app', 'uploaders', '*.rb')].each { |file| require file }

  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?

    klass.class_eval do
      prepend UploaderExtensions
    end
  end
end
