require 'yajl'
require 'json'
require 'yajl'
module Shiftcare
  module Utils
    class Parser < Base
      class UnsupportedFileType < StandardError; end
      attr_reader :type, :file_name, :file

      def initialize(type, file_name)
        @type = type
        @file_name = file_name
      end

      def parse
        Yajl::Parser.parse(path.read)
      end
      
      def size
        path.size
      end
      
      def full_path
        path.path
      end
      
      private

      def path
        raise FileNameError, "Json File name must be present" if @file_name.nil? || @file_name.empty?
        case @type
        when 'data'
          @file = File.new("#{Utils::Base.download_dir}#{@file_name}", 'r')
        when 'schema'
          @file = File.new("#{Utils::Base.schema_dir}#{@file_name}", 'r')
        when 'metadata'
          @file = File.new("#{Utils::Base.metadata_dir}#{@file_name}", 'r')
        else
          raise UnsupportedFileType, 'File type is unsupported'
        end
        raise MissingFile, "Json File is not present" unless File.exist?(@file)
        @file
      end
    end
  end
end