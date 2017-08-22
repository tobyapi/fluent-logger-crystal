require "./logger_base"

module Fluent::Logger
  class ConsoleLogger < LoggerBase
    def post_with_time(tag, map, time)
    end
  end
end
