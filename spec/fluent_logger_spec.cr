require "./spec_helper"

Spec2.describe Fluent::Logger::FluentLogger do
  context "running fluentd" do
    context "post" do
      it("success") {
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
    end
  end
end
