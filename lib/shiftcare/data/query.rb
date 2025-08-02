# frozen_string_literal: true

module Shiftcare
  class Data::Query
    class InvalidInstance < StandardError; end
    class ValidationError < StandardError; end

    attr_reader :data_instance
    attr_accessor :available_filters, :query, :properties

    def initialize(data_instance)
      unless data_instance.instance_of?(Shiftcare::Data)
        raise InvalidInstance, "Only accepts instance of Shiftcare::Data got #{data_instance.class}"
      end

      @data_instance = data_instance
      set_defaults
    end

    def where(criteria = {})
      if properties.nil?
        print("Schema not found, aborting..\n")
      else
        print("Filtering by criteria: #{criteria}\n")
        validate_criteria!(criteria)
        @data_instance.all.select do |record|
          criteria.all? do |key, value|
            filter(record, key, value)
          end
        end
      end
    end

    # def search_by_indexes(indexes)
    #   @data_instance.all.values_at(*indexes)
    # end

    def duplicates
      return [] if @data_instance.metadata.to_h[:duplicates_count].zero?

      @data_instance.metadata.to_h[:duplicates].values.flatten
    end

    private

    def filter(record, key, value)
      field      = record[key]
      return nil unless field

      field_type = properties[key][:type]
      validate_types!(field, field_type, value)
      case field_type
      when 'integer'
        field == value
      when 'string'
        field.downcase.include?(value.downcase)
      end
    end

    def validate_criteria!(criteria)
      return if available_filters.include?(criteria.keys.first)

      raise ValidationError, "Invalid key, available keys are #{available_filters}"
    end

    def validate_types!(_field, field_type, value)
      return if field_type == value.class.to_s.downcase

      raise ValidationError,
            "Invalid content type, content must be #{field_type.upcase} got #{value.class.to_s.upcase}"
    end

    def set_defaults
      self.available_filters = @data_instance.metadata.to_h[:keys].map(&:to_sym)
      self.properties = @data_instance.schema.properties if @data_instance.schema.parser.check_file
    end
  end
end
