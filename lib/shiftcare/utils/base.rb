# frozen_string_literal: true

module Shiftcare
  module Utils
    class Base
      class ConfigError < StandardError; end

      class << self
        attr_reader :url, :exchange_layer_dir, :download_dir, :metadata_dir, :schema_dir

        def url=(value)
          validate!(value, 'URL')

          @url = value
        end

        def exchange_layer_dir=(value)
          validate!(value, 'Exchange Layer Path')

          @exchange_layer_dir = value
        end

        def metadata_dir=(value)
          validate!(value, 'Metadata Path')

          @metadata_dir = value
        end

        def download_dir=(value)
          validate!(value, 'Download Path')

          @download_dir = value
        end

        def schema_dir=(value)
          validate!(value, 'Schema Path')

          @schema_dir = value
        end

        def configs
          {
            url: @url,
            paths: {
              exchange_layer_dir: @exchange_layer_dir,
              download_dir: @download_dir,
              metadata_dir: @metadata_dir,
              schema_dir: @schema_dir
            }
          }
        end

        def configure
          yield(self)
        end

        def validate!(value, name)
          raise ConfigError, "#{name} cannot be nil or empty" if value.nil? || value.strip.empty?
        end
      end

      def initialize; end
    end
  end
end
