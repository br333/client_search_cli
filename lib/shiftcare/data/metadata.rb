# frozen_string_literal: true
require 'pry'
require 'yajl'
require 'json'

module Shiftcare
  class Data::Metadata
    class InvalidInstance < StandardError; end

    attr_accessor :size, :root_type, :record_length, 
                  :duplicates_count, :keys, :generated_at, 
                  :metadata_file, :file_name, :data_instance,
                  :validate_schema

    def initialize(data_instance)
      unless data_instance.instance_of?(Shiftcare::Data)
        raise InvalidInstance, "Only accepts instance of Shiftcare::Data got #{data_instance.class}"
      end

      @data_instance = data_instance
      set_defaults
    end

    def generate
      Utils::Generators::Metadata.generate(to_h, metadata_name)
    end

    def to_h
      meta = {
        filename: file_name,
        size: size,
        root_type: root_type,
        duplicates_count: duplicates_count,
        record_length: record_length,
        keys: keys,
        generated_at: generated_at,
        schema_path: @data_instance.schema.file_path,
        invalid_items_indexes: @data_instance.schema.invalid_items_indexes,
        invalid_items_count: @data_instance.schema.invalid_items_count
      }
   end

    private

    def metadata_name
      @data_instance.parser.file_name.split('.').insert(-2, 'metadata').join('.')
    end

    def duplicates
      @data_instance.all
                    .group_by { |item| item["email"] }
                    .select   { |_k, v| v.size > 1 }
                    .count
    end

    def set_defaults
      self.file_name        = @data_instance.parser.full_path
      self.size             = @data_instance.parser.size
      self.root_type        = @data_instance.all.class.to_s
      self.duplicates_count = duplicates
      self.record_length    = @data_instance.all.length
      self.keys             = @data_instance.all.map(&:keys).uniq.flatten
      self.generated_at     = Time.now
      # self.validate_schema  = validate_schema || true
    end
  end
end