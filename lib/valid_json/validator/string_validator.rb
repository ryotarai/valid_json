module ValidJson
  module Validator
    class StringValidator < GeneralValidator
      def validate(data)
        super +
        validate_max_length(data) +
        validate_min_length(data) +
        validate_pattern(data)
      end
      
      private
      def validate_max_length(data)
        max_length = @schema['maxLength']
        if max_length && max_length < data.size
          ["String is too long (#{data.size} chars), maximum #{max_length}"]
        else
          []
        end
      end

      def validate_min_length(data)
        min_length = @schema['minLength']
        if min_length && min_length > data.size
          ["String is too short (#{data.size} chars), minium #{min_length}"]
        else
          []
        end
      end

      def validate_pattern(data)
        pattern = @schema['pattern']
        if pattern && !(data.match(pattern))
          ["String does not match pattern: #{pattern}"]
        else
          []
        end
      end
    end
  end
end

