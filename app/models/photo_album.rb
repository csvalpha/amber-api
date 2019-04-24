require 'zip'

class PhotoAlbum < ApplicationRecord
  has_many :photos, dependent: :destroy

  validates :title, presence: true
  validates :publicly_visible, inclusion: [true, false]

  scope :publicly_visible, (-> { where(publicly_visible: true) })

  def to_zip
    temp_file = Tempfile.new('test.zip')

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |file|
      photos.each do |photo|
        file.add(photo.image.file.filename, photo.image.path)
      end
    end

    File.read(temp_file.path)
  end
end
