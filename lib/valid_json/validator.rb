require 'valid_json/validator/general_validator'
require 'valid_json/validator/array_validator'
require 'valid_json/validator/numeric_validator'
require 'valid_json/validator/object_validator'
require 'valid_json/validator/string_validator'

module ValidJson
  module Validator
    VALIDATORS_MAP = {
      Array => ArrayValidator,
      Hash => ObjectValidator,
      String => StringValidator,
      Integer => NumericValidator,
      Fixnum => NumericValidator,
      Bignum => NumericValidator,
      Float => NumericValidator,
    }

    def self.validate(schema, data)
      validator_class = VALIDATORS_MAP[data.class]
      validator = validator_class.new(schema)
      validator.validate(data)
    end
  end
end

