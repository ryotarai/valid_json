module ValidJson
  module Validator
    class ArrayValidator < GeneralValidator
      def validate(data)
        super +
        validate_unique(data) +
        validate_min(data) +
        validate_max(data) +
        validate_items(data)
      end

      private
      def validate_unique(data)
        if @schema["uniqueItems"] && !(data.uniq == data)
          ["Array items are not unique"]
        else
          []
        end
      end
      def validate_min(data)
        if @schema["minItems"] && data.size < @schema["minItems"]
          ["Array is too short (#{data.size}), minimum #{@schema["minItems"]}"]
        else
          []
        end
      end
      def validate_max(data)
        if @schema["maxItems"] && @schema["maxItems"] < data.size
          ["Array is too long (#{data.size}), maximum #{@schema["maxItems"]}"]
        else
          []
        end
      end
      def validate_items(data)
        errors = []
        if @schema['items']
          data.each_with_index do |datum, i|
            errors += Validator.validate(@schema['items'], datum)
          end
        end
        errors
      end
    end
  end
end


