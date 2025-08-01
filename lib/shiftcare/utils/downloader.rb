# frozen_string_literal: true

require 'httparty'

module Shiftcare
  module Utils
    attr_accessor :file_name
    class DownloadError < StandardError; end

    class Downloader < Base
      def call(file_name)
        @file_name = file_name
        @file_path = Base.download_dir + @file_name
        if File.exist?(@file_path)
          print "File #{@file_path} already exists \n" 
          return
        end
        download
      end

      private

      def download
        File.open(@file_path, 'wb') do |file|
          HTTParty.get(Base.url+@file_name, stream_body: true) do |fragment|
            raise DownloadError, "Non-success status code while streaming #{fragment.code}" unless fragment.code == 200

            print "Storing JSON file to #{Base.download_dir}\n"
            print ".\n"
            file.write(fragment)
          end
        end
      end
    end
  end
end
