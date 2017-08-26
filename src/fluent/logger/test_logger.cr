require "./logger_base"

module Fluent::Logger
  class TestLogger < LoggerBase
    property max : Int32

    def initialize(@queue, @max = 1024)
    end

    def post_with_time(tag, map, time)
      while @queue.size > @max-1
        @queue.shift
      end

      @queue << {tag, map}
      true
    end

    def tag_queue(tag)
      @queue.find_all { |e| e[0] == tag }
    end

    def close
    end
  end
end
