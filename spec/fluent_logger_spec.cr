require "./spec_helper"

Spec2.describe Fluent::Logger::FluentLogger do
  context "running fluentd" do
    context "post" do
      it("tcp socket") {
        Timecop.freeze(Time.now) do
          srv = fork do
            server = MockServer.new "tcp://localhost:24224"
            server.startup
            server.wait_transfer
            result = server.queue.first
            expect(result).to eq ["tag", Time.now.second, {"a" => "b"}]
          end
          
          fork do
            Fluent::Logger::FluentLogger.new.post("tag", {"a" => "b"})
          end
          
          sleep 1
          srv.kill
        end
      }
      
      it("unix socket") {
        Timecop.freeze(Time.now) do
          
          fork do
            Fluent::Logger::FluentLogger.new(socket_path: "unix:///tmp/fluent_logger_crystal.sock").post("tag", {"a" => "b"})
          end
          
          srv = fork do
            sleep 1
            server = MockServer.new "unix:///tmp/fluent_logger_crystal.sock"
            server.startup
            result = server.queue.first
            expect(result).to eq ["tag", Time.now.second, {"a" => "b"}]
            server.shutdown
          end
          
          sleep 1
          srv.kill
        end
      }
    end
  end
end
