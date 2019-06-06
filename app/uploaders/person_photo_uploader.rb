require 'carrierwave'
require_relative '../../app/models/concerns/uniq_id.rb'

class PersonPhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join(ENV['STAFF_PHOTOS_PATH'], model.id.to_s)
  end

  def cache_dir
    File.join(ENV['STAFF_PHOTOS_CACHE_PATH'], model.id.to_s)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb30 do
    process resize_to_fit: [30, 40]
  end

  version :thumb45 do
    process resize_to_fit: [45, 60]
  end

  version :thumb60 do
    process resize_to_fit: [60, 80]
  end

  version :large do
    process resize_to_fit: [300, 400]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{ model.photo_short_id }.jpg"
  end

end
