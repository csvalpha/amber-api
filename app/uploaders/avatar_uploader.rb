class AvatarUploader < ApplicationImageUploader
  version :thumb do
    process resize_to_fill: [196, 196]
  end
end
