class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Основное изображение
  process resize_to_limit: [1080, 1080]
  
  # Миниатюра
  version :thumb do
    process resize_to_fill: [300, 300]
  end
  
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
  
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  protected
  
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
