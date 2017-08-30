require "./spec_helper"
require "timecop"

Spec2.describe Fluent::Logger::ConsoleLogger do
  before { Timecop.freeze Time.new(2008, 9, 1, 10, 5, 0).to_local }

  after { Timecop.return }
  
  context "IO output" do
    let(:io) { IO::Memory.new }
    let(:logger) { Fluent::Logger::ConsoleLogger.new io }

    subject { io }

    context "post and read" do
      before do
        logger.post("example", {:foo => :bar})
        io.rewind
      end
      
      it("read")do
        expect(subject.to_s).to eq "Sep  1 19:05:00 example: foo=\"bar\"\n"
      end
    end
  end

end
