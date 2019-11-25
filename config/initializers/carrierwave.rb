module UploaderExtensions
  def cache_dir
    Rails.root.join('spec', 'support', 'uploads', 'tmp')
  end
end

# TODO: check that we did need this...
# if Rails.env.test?
#   Dir[Rails.root.join('app', 'uploaders', '*.rb')].each { |file| require file }
#
#   CarrierWave::Uploader::Base.descendants.each do |klass|
#     next if klass.anonymous?
#
#     klass.class_eval do
#       prepend UploaderExtensions
#     end
#   end
# end
