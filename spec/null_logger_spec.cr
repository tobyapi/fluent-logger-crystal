require "./spec_helper"

Spec2.describe Fluent::Logger::NullLogger do
  let(:logger) { Fluent::Logger::NullLogger.new }

  context "post" do
    it("false") {
      expect(logger.post("tag1", {:foo => :bar})).to eq false
      expect(logger.post("tag2", {:foo => :baz})).to eq false
    }
  end

end
