require "./logger_base"
require "file"

module Fluent::Logger
  
  class ConsoleLogger < LoggerBase
    def initialize(output)
      @time_format = "%b %e %H:%M:%S"

      if output.is_a?(String)
        File.open(output, mode: "a")
        @io = File.open(output, "a")
        @on_reopen = -> { @io.reopen(output, "a") }
      elsif out.respond_to?(:write)
        @io = out
        @on_reopen = -> { }
      else
        raise "Invalid output: #{out.inspect}"
      end
    end
    
    def reopen!
      @on_reopen.call
    end

    def post_text(text)
      @io.puts text
    end

    def close
      @io.close unless @io == STDOUT
      self
    end
     
    def post_with_time(tag, map, time)
      a = [time.strftime(@time_format), " ", tag, ":"]
      map.each do |k, v|
        a << " #{k}="
        a << JSON.dump(v)
      end
      post_text a.join
    end
  end
end
