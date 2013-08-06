require 'spec_helper'
require 'json'

module ValidJson
  describe Validator do
    describe ".initialize" do
      let(:schema) { {hello: "world"} }
      it "takes 1 arg" do
        expect { described_class.new(schema) }.not_to raise_error
      end
      it "takes schema as arg" do
        expect(described_class.new(schema).schema).to eq(schema)
      end
    end

    describe "#validate" do
      subject { described_class.new(schema).validate(data) }

      describe "Invalid type error" do
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

      describe "Missing required property error" do
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

      describe "Not unique error" do
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

      describe "Too short error" do
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

      describe "Too long error" do
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
  end
end
