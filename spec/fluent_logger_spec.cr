require "./spec_helper"

Spec2.describe Fluent::Logger::FluentLogger do
  let(:internal_logger){
    @logger_io = IO::Memory.new
    ::Logger.new(@logger_io)
  }

  let(:logger){
    Fluent::Logger::FluentLogger.new "logger-test", logger_config
  }

  let(:logger_with_nanosec) {
    Fluent::Logger::FluentLogger.new("logger-test", logger_config.merge({ :nanosecond_precision => true }))
  }

  let(:buffer_overflow_handler){ nil }

  let(:logger_io){ @logger_io }

  let(:logger_config){
    {
      :host => "loclahost",
      :port => 24224,
      :logger => internal_logger,
      :buffer_overflow_handler => buffer_overflow_handler
    }
  }

  context "running fluentd" do
    context "post" do
    end
  end
end
