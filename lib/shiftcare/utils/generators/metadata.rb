module Shiftcare
  module Utils
    module Generators
      class FileGenerationError < StandardError; end
      class Metadata < Base
        class << self
          def generate(metadata, file_name)
            file = File.write("#{Base.metadata_dir}#{file_name}", JSON.pretty_generate(metadata))
            unless file
              raise FileGenerationError, "Failed to generate metadata #{file_name}"
            end
            print "#{file_name} generated\n"
            true
          end
        end
      end
    end
  end
end
