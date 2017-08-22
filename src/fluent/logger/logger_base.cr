module Fluent::Logger
  abstract class LoggerBase
    def open(*args, &block)
      Fluent::Logger.open(self, *args, &block)
    end

    def post(tag, map)
      post_with_time tag, map, Time.now
    end

    abstract def post_with_time(tag, map, time)

    def close
    end
  end
end
