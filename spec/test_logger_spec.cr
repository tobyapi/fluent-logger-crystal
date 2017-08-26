require "./spec_helper"

Spec2.describe Fluent::Logger::TestLogger do
  context "logger method" do
    let(:logger) { Fluent::Logger::TestLogger(Symbol,Symbol).new }
    subject { logger.queue }

    context "post" do
      before do
        logger.post("tag1", {:foo => :bar})
        logger.post("tag2", {:foo => :baz})
      end

      it("first") { subject == {:foo => :bar } }
      it("last")  { subject == {:foo => :baz } }
      it("first.tag") { subject == "tag1" }
      it("last.tag")  { subject == "tag2" }

      it("tag_queue") {
        expect(logger.tag_queue("tag1").size).to eq 1
        expect(logger.tag_queue("tag2").size).to eq 1
        expect(logger.tag_queue("tag3").size).to eq 0
      }
    end

    context "max" do
      before do
        logger.max = 2
        10.times { |i| logger.post(i.to_s, {} of Symbol => Symbol) }
      end

      it("size") { subject.size == 2 }
      it("last.tag") { subject == "9" }
    end
  end
end