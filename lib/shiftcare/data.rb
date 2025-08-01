# frozen_string_literal: true
require 'pry'
module Shiftcare
  class Data
    class TypeError < StandardError; end
    attr_reader :parser, :metadata, :schema

    def initialize(file_name)
      @parser = Utils::Parser.new('data', file_name)
      @metadata = Metadata.new(self)
      @schema = Schema.new(self)
    end

    def all
      @parser.parse
    end
  end
end
