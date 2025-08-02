# frozen_string_literal: true

require 'pry'
require 'json'
require 'json-schema'
module Shiftcare
  class Data::Schema
    attr_reader :errors, :file, :parser, :data_instance, :properties

    def initialize(data_instance)
      unless data_instance.instance_of?(Shiftcare::Data)
        raise InvalidInstance, "Only accepts instance of Shiftcare::Data got #{data_instance.class}"
      end

      @data_instance = data_instance
      set_defaults
    end

    def validate!
      if @parser.check_file
        @errors = @data_instance.all.map.with_index do |item, id|
          error = JSON::Validator.fully_validate(definition, item)
          { index: id, errors: error } unless error.empty?
        end.compact
      else
        print "Skipping schema validation, since schema file is not found! \n"
      end
    end

    def definition
      @parser.parse
    end

    def invalid_items_indexes
      @errors.map { |error| error[:index] }
    end

    def invalid_items_count
      @errors.count
    end

    def properties
      definition[:properties]
    end

    private

    def schema_name
      @data_instance.parser.file_name.split('.').insert(-2, 'schema').join('.')
    end

    def set_defaults
      @errors = []
      @parser = Utils::Parser.new('schema', schema_name)
      @file   = @parser.full_path
    end
  end
end
