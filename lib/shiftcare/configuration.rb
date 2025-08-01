# frozen_string_literal: true

module Shiftcare

  Utils::Base.configure do |config|
    config.url                  = 'https://appassets02.shiftcare.com/manual/'
    config.exchange_layer_dir  = './.exchange_layer/'
    config.download_dir        = config.exchange_layer_dir + "files/"
    config.schema_dir          = config.exchange_layer_dir + "schema/"
    config.metadata_dir        = config.exchange_layer_dir + "metadata/"
  end

  # Data::Base.configure do |config|
  #   config.metadata_path = Utils::Base.metadata_path
  #   config.schema_path = Utils::Base.schema_path
  #   config.files_path = Utils::Base.download_path
  # end

end
