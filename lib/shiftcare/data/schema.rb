# frozen_string_literal: true
require 'pry'
require 'json'
require 'json-schema'
module Shiftcare
  class Data::Schema
    attr_reader :errors, :file_path
    def initialize(data_instance)
      unless data_instance.instance_of?(Shiftcare::Data)
        raise InvalidInstance, "Only accepts instance of Shiftcare::Data got #{data_instance.class}"
      end

      @data_instance = data_instance
      set_defaults
      validate!
    end

    def validate!
      @errors = @data_instance.all.map.with_index do |item, id|
        error = JSON::Validator.fully_validate(definition, item)
        { index: id, errors: error} unless error.empty?
      end.compact
    end

    def definition
      JSON.parse(File.read(@file_path))
    end

    def invalid_items_indexes
      @errors.map{|error| error[:index]}
    end

    def invalid_items_count
      @errors.count
    end

    private

    def schema_name
      @data_instance.parser.file_name.split('.').insert(-2, 'schema').join('.')
    end

    def set_defaults
      @errors = []
      @file_path = "#{Utils::Base.schema_dir}#{schema_name}"
    end
  end
end
