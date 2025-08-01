# frozen_string_literal: true

lib_path = File.expand_path(__dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

%w[
  data
  data/schema
  data/metadata
  utils/base
  utils/downloader
  utils/parser
  utils/generators/directory
  utils/generators/metadata
  configuration
].each { |file| require "shiftcare/#{file}" }

module Shiftcare
  class Error < StandardError; end
end
