module ValidJson
  module Validator
    class GeneralValidator
      TYPE_MAP = {
        "array" => Array,
        "object" => Hash,
        "string" => String,
        "number" => Numeric,
      }

      def initialize(schema)
        @schema = schema
      end

      def validate(data)
        validate_type(data)
      end

      private
      def validate_type(data)
        return [] unless @schema["type"]
        type = TYPE_MAP[@schema["type"]]
        unless type
          return ["No such type: #{@schema["type"]}"]
        end
        if data.is_a?(type)
          []
        else
          ["Invalid type: #{data.class.to_s} (expected #{type.to_s})"]
        end
      end
    end
  end
end

