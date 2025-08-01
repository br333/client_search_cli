require 'yajl'
require 'json'
require 'pathname'

module Shiftcare
  module Utils
    class Parser < Base

      class UnsupportedFileType < StandardError; end
      class FileNameError < StandardError; end
      class MissingFile < StandardError; end

      attr_reader :type, :file_name, :file

      def initialize(type, file_name)
        @type = type
        @file_name = file_name
      end

      def parse
        if check_file
          content = path.read
          raise "Empty JSON file: #{path}" if content.strip.empty?
          Yajl::Parser.parse(content, symbolize_keys: true)
        else
          raise MissingFile, "JSON is required at: #{path}"
        end
      end

      def size
        return 0 unless check_file
        path.size
      end

      def full_path
        path.to_s
      end

      def check_file
        path.exist?
      end

      private

      def path
        valid_types = {
          'data'     => Base.download_dir,
          'schema'   => Base.schema_dir,
          'metadata' => Base.metadata_dir
        }

        base_dir = valid_types[@type] 
        raise UnsupportedFileType, "File type '#{@type}' is unsupported" if base_dir.nil?
        @file = Pathname.new(File.join(base_dir, @file_name))
        @file
      end
    end
  end
end