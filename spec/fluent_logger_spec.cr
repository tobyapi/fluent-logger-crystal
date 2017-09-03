require "./spec_helper"

Spec2.describe Fluent::Logger::FluentLogger do
  let(:internal_logger){
    @logger_io = IO::Memory.new
    ::Logger.new(@logger_io)
  }

  let(:logger_with_nanosec) {
    Fluent::Logger::FluentLogger.new
  }

  let(:buffer_overflow_handler){ nil }

  let(:logger_io){ @logger_io }

  context "running fluentd" do
    context "post" do
      it("success") {
        Timecop.freeze(Time.now) do
          fork do
            server = MockServer.new "tcp://localhost:24224"
            result = server.run
            expect(result).to eq ["tag", Time.now.second, {"a" => "b"}]
          end
          
          fork do
            Fluent::Logger::FluentLogger.new.post("tag", {"a" => "b"})
          end
        end
      }
    end
  end
end
