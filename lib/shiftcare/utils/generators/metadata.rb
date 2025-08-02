# frozen_string_literal: true

module Shiftcare
  module Utils
    module Generators
      class FileGenerationError < StandardError; end

      class Metadata < Base
        class << self
          def generate(metadata, file_name)
            file = File.write("#{Base.metadata_dir}#{file_name}", JSON.pretty_generate(metadata))
            raise FileGenerationError, "Failed to generate metadata #{file_name}" unless file

            print "#{file_name} generated\n"
            true
          end
        end
      end
    end
  end
end
