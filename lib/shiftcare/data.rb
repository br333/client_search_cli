# frozen_string_literal: true

module Shiftcare
  class Data
    class TypeError < StandardError; end
    attr_reader :parser

    def initialize(file_name)
      @parser = Utils::Parser.new('data', file_name)
    end

    def all
      @parser.parse
    end

    def metadata
      @metadata ||= Metadata.new(self)
    end

    def schema
      @schema ||= Schema.new(self)
    end

    def query
      @query ||= Query.new(self)
    end
  end
end
