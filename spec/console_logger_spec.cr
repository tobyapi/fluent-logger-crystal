require "./spec_helper"
require "timecop"
require "tempfile"

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
  
  context "Filename output" do
    let(:path) do
      @tmp = Tempfile.new("fluent-logger") # ref instance var because Tempfile.close(true) check GC
      @tmp.as(Tempfile).path
    end
    let(:logger) { Fluent::Logger::ConsoleLogger.new path.to_s }

    subject { @tmp.as(Tempfile).read_line }
    after do
      @tmp.as(Tempfile).close
      @tmp.as(Tempfile).unlink 
    end

    context "post and read" do
      before do
        logger.post("example", {:foo => :bar})
        logger.close
      end
      it("read")  { expect(subject).to eq "Sep  1 19:05:00 example: foo=\"bar\"" }
    end

    context "reopen" do
      before do
        logger.post("example", {:foo => :baz})
        logger.close
        logger.reopen!
      end
      it("read")  { expect(subject).to eq "Sep  1 19:05:00 example: foo=\"baz\"" }
    end
  end

end
