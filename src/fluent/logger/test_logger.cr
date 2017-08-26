require "./logger_base"

module Fluent::Logger
  class TestLogger(K, V) < LoggerBase
    property max : Int32
    getter queue : Array(Tuple(String,Hash(K,V)))
    
    def initialize(@max = 1024)
      @queue = [] of Tuple(String,Hash(K,V))
    end

    def post_with_time(tag, map, time)
      while @queue.size >= @max
        @queue.shift
      end

      @queue << { tag, map }
      true
    end

    def tag_queue(tag)
      @queue.select { |e| e[0] == tag }
    end

    def close
    end
  end
end
