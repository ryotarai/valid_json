require 'spec_helper'
require 'json'

module ValidJson
  describe Validator do
    describe ".validate" do
      subject { described_class.validate(schema, data) }

      describe "general validation" do
        describe "type" do
          let(:data) { {} }
          let(:schema) { JSON.load(<<-EOS) }
    {
    "type": "array"
    }
          EOS
          it 'returns "Invalid type" error' do
            subject.first.should =~ /^Invalid type: Hash \(expected Array\)/
          end
        end
      end

      describe "object validation" do
        describe "required" do
          context "top level" do
            let(:data) { {} }
            let(:schema) { JSON.load(<<-EOS) }
    {
      "type": "object",
      "required": ["req"]
    }
            EOS
            it 'returns "Missing required property" error' do
              subject.first.should =~ /^Missing required property: req/
            end
          end
          context "second level" do
            let(:data) { {"person" => {}} }
            let(:schema) { JSON.load(<<-EOS) }
    {
      "type": "object",
      "properties": {
        "person": {
          "required": ["req"]
        }
      }
    }
            EOS
            it 'returns "Missing required property" error' do
              subject.first.should =~ /^Missing required property: req/
            end
          end
        end
      end

      describe "numeric validation" do
        describe "multipleOf" do
          let(:data) { 5 }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "number",
    "multipleOf": 3
  }
          EOS
          it 'returns "not a multiple" error' do
            subject.first.should == "Value 5 is not a multiple of 3"
          end
        end

        describe "maximum" do
          let(:data) { 10 }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "number",
    "maximum": 9
  }
          EOS
          it 'returns "greater than" error' do
            subject.first.should == "Value 10 is greater than maximum 9"
          end
        end

        describe "maximum and exclusiveMaximum" do
          let(:data) { 9 }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "number",
    "maximum": 9,
    "exclusiveMaximum": true
  }
          EOS
          it 'returns "equal to exclusive maximum" error' do
            subject.first.should == "Value 9 is equal to exclusive maximum 9"
          end
        end

        describe "minimum" do
          let(:data) { 9 }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "number",
    "minimum": 10
  }
          EOS
          it 'returns "less than" error' do
            subject.first.should == "Value 9 is less than minimum 10"
          end
        end

        describe "minimum and exclusiveMinimum" do
          let(:data) { 9 }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "number",
    "minimum": 9,
    "exclusiveMinimum": true
  }
          EOS
          it 'returns "equal to exclusive minimum" error' do
            subject.first.should == "Value 9 is equal to exclusive minimum 9"
          end
        end
      end

      describe "array validation" do
        describe "uniqueItems" do
          let(:data) { ["a", "b", "a"] }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "array",
    "uniqueItems": true
  }
          EOS
          it 'returns "not unique" error' do
            subject.first.should =~ /^Array items are not unique/
          end
        end

        describe "minItems" do
          let(:data) { ["a", "b", "c"] }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "array",
    "minItems": 4
  }
          EOS
          it 'returns "too short" error' do
            subject.first.should =~ /^Array is too short \(3\), minimum 4/
          end
        end

        describe "maxItems" do
          let(:data) { ["a", "b", "c"] }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "array",
    "maxItems": 2
  }
          EOS
          it 'returns "too long" error' do
            subject.first.should =~ /^Array is too long \(3\), maximum 2/
          end
        end
      end

      describe "string validation" do
        describe "maxLength" do
          let(:data) { "helloworld" }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "string",
    "maxLength": 9
  }
          EOS
          it 'returns "too long" error' do
            subject.first.should == "String is too long (10 chars), maximum 9"
          end
        end

        describe "minLength" do
          let(:data) { "helloworld" }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "string",
    "minLength": 11
  }
          EOS
          it 'returns "too short" error' do
            subject.first.should == "String is too short (10 chars), minium 11"
          end
        end

        describe "pattern" do
          let(:data) { "abc" }
          let(:schema) { JSON.load(<<-EOS) }
  {
    "type": "string",
    "pattern": "^bc"
  }
          EOS
          it 'returns "not match pattern" error' do
            subject.first.should == "String does not match pattern: ^bc"
          end
        end
      end
    end
  end
end
