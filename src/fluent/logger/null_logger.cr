require "./logger_base"

module Fluent::Logger
  class NullLogger < LoggerBase
    def post_with_time(tag, map, time)
      false
    end
  end
end
