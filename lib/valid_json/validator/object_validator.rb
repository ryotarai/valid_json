module ValidJson
  module Validator
    class ObjectValidator < GeneralValidator
      def validate(data)
        super +
        validate_properties(data) +
        validate_required(data)
      end

      private
      def validate_properties(data)
        return [] unless @schema["properties"]

        errors = []
        @schema["properties"].map do |key, property_schema|
          errors += Validator.validate(property_schema, data[key])
        end
        errors
      end

      def validate_required(data)
        errors = []
        if @schema["required"]
          @schema["required"].each do |required_attr|
            unless data.has_key?(required_attr)
              errors << "Missing required property: #{required_attr}"
            end
          end
        end
        errors
      end
    end
  end
end

