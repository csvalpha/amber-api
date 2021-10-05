require 'zip'

class PhotoAlbum < ApplicationRecord
  has_many :photos, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :group, optional: true

  validates :title, presence: true
  validates :publicly_visible, inclusion: [true, false]

  scope :publicly_visible, (-> { where(publicly_visible: true) })

  def owners
    if group.present?
      group.active_users + [author]
    else
      [author]
    end
  end

  def to_zip
    temp_file = Tempfile.new('test.zip')

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |file|
      photos.each do |photo|
        file.add("#{photo.id}.#{photo.image.file.extension}", photo.image.path)
      end
    end

    File.read(temp_file.path)
  end
end
