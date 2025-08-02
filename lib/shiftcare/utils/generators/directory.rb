# frozen_string_literal: true

module Shiftcare
  module Utils
    module Generators
      class DirGenerationError < StandardError; end

      class Directory < Base
        class << self
          def generate_paths
            print("Generating directories..\n")
            Base.configs[:paths].each do |key, val|
              next if Dir.exist?(val)

              print "Creating #{key}\n"
              FileUtils.mkdir_p(val)
            end
          end
        end
      end
    end
  end
end
