class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process resize_to_fill: [150, 150]
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def default_url
    "/images/fallback/" + [version_name, "default_avatar.png"].compact.join('_')
  end
end
