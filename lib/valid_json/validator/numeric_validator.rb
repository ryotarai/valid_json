module ValidJson
  module Validator
    class NumericValidator < GeneralValidator
      def validate(data)
        super +
        validate_multiple(data) +
        validate_maximum(data) +
        validate_minimum(data)
      end

      private
      def validate_multiple(data)
        multiple_of = @schema['multipleOf']
        if multiple_of && !(data % multiple_of == 0)
          ["Value #{data} is not a multiple of #{multiple_of}"]
        else
          []
        end
      end

      def validate_maximum(data)
        maximum = @schema['maximum']
        exclusive = @schema['exclusiveMaximum']
        if maximum && !exclusive && maximum < data
          ["Value #{data} is greater than maximum #{maximum}"]
        elsif maximum && exclusive && maximum <= data
          ["Value #{data} is equal to exclusive maximum #{maximum}"]
        else
          []
        end
      end

      def validate_minimum(data)
        minimum = @schema['minimum']
        exclusive = @schema['exclusiveMinimum']
        if minimum && !exclusive && data < minimum
          ["Value #{data} is less than minimum #{minimum}"]
        elsif minimum && exclusive && data <= minimum
          ["Value #{data} is equal to exclusive minimum #{minimum}"]
        else
          []
        end
      end
    end
  end
end

