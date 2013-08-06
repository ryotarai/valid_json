module ValidJson
  class Validator
    attr_reader :schema, :items, :properties

    TYPE_MAP = {
      "array" => Array,
      "object" => Hash,
      "string" => String,
      "number" => Numeric,
    }

    def initialize(schema)
      @schema = schema

      init_schema(schema)
    end

    def init_schema(schema)
      if schema["type"] && !(@type = TYPE_MAP[schema["type"]])
        raise ArgumentError, "Type #{schema['type']} is not found."
      end
      @items_validator = self.class.new(schema["items"]) if schema["items"]
      @property_validators = Hash[(schema["properties"].map do |key, value|
        [key, self.class.new(value)]
      end)] if schema["properties"]
    end

    def validate_required(data)
      errors = []
      if schema["required"]
        schema["required"].each do |required_attr|
          unless data.has_key?(required_attr)
            errors << "Missing required property: #{required_attr}"
          end
        end
      end
      errors
    end

    def validate_type(data)
      if data.is_a?(@type)
        []
      else
        ["Invalid type: #{data.class.to_s} (expected #{@type.to_s})"]
      end
    end

    def validate_array(data)
      errors = []
      if schema["uniqueItems"]
        errors << "Array items are not unique" unless data.uniq == data
      end
      if schema["minItems"] && data.size < schema["minItems"]
        errors << "Array is too short (#{data.size}), minimum #{schema["minItems"]}"
      end
      if schema["maxItems"] && schema["maxItems"] < data.size
        errors << "Array is too long (#{data.size}), maximum #{schema["maxItems"]}"
      end
      errors
    end

    def validate_number(data)
      errors = []
      errors
    end

    def validate_items(data, path_elms)
      errors = []
      return errors unless @type == Array
      if @items_validator
        data.each_with_index do |datum, i|
          errors += @items_validator.validate(datum, path_elms + ["##{i}"])
        end
      end
      errors
    end


    def validate_properties(data, path_elms)
      errors = []
      return errors unless @type == Hash && @property_validators
      @property_validators.each_pair do |key, property|
        errors += property.validate(data[key], path_elms + [key]) if data[key]
      end
      errors
    end

    def validate(data, path_elms=[])
      errors = []

      errors += validate_required(data)
      errors += validate_type(data)
      errors += validate_array(data)
      errors += validate_number(data)

      path = "/" + path_elms.join("/")
      errors = errors.map do |error|
        "#{error} (#{path})"
      end

      errors += validate_items(data, path_elms)
      errors += validate_properties(data, path_elms)

      errors
    end
  end
end
