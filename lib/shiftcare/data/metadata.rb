# frozen_string_literal: true
require 'pry'
require 'yajl'
require 'json'

module Shiftcare
  class Data::Metadata
    class InvalidInstance < StandardError; end

    attr_reader   :metadata_values,
                  :file, :file_name, :data_instance, :parser, :duplicates

    def initialize(data_instance)
      unless data_instance.instance_of?(Shiftcare::Data)
        raise InvalidInstance, "Only accepts instance of Shiftcare::Data got #{data_instance.class}"
      end

      @data_instance = data_instance
      set_defaults
    end

    def generate
      Utils::Generators::Metadata.generate(build_metadata, metadata_name)
    end

    def to_h
      parser.parse
   end

    private

    def metadata_name
      @data_instance.parser.file_name.split('.').insert(-2, 'metadata').join('.')
    end

    def duplicates
      @duplicates ||= @data_instance.all.each_with_index
        .group_by { |(item, _ind)| item[:email] }
        .select { |_email, records| records.size > 1 }
        .transform_values { |records| records.map { |item, ind| {"#{ind}": item} } }
    end

    def build_metadata
      @data_instance.schema.validate!
      @metadata_values = {
          filename: @data_instance.parser.full_path,
          size: @data_instance.parser.size,
          root_type: @data_instance.all.class.to_s,
          duplicates_count: duplicates.count,
          duplicates: duplicates,
          record_length: @data_instance.all.length,
          keys: @data_instance.all.map(&:keys).uniq.flatten,
          generated_at: Time.now,
          schema_path: @data_instance.schema.file,
          invalid_items_indexes: @data_instance.schema.invalid_items_indexes,
          invalid_items_count: @data_instance.schema.invalid_items_count,
        }
    end

    def set_defaults
      @parser           = Utils::Parser.new('metadata', metadata_name)
      @file             = parser.file
    end
  end
end