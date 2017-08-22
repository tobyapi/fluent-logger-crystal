require "json"

module Fluent::Logger
  abstract class TextLogger < LoggerBase
    def initialize
      @time_format = "%b %e %H:%M:%S"
    end

    abstract def post_with_time(tap, map, time)
  end
end
