require 'carrierwave'

CarrierWave.configure do |config|
  config.root = ENV['CARRIERWAVE_PUBLIC_PATH']
end
