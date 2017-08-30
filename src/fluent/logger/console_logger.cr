require "./logger_base"
require "file"
require "json"

module Fluent::Logger
  
  class ConsoleLogger < LoggerBase
    
    @io : IO | File
    @on_reopen : Proc(Nil)
    
    def initialize(output)
      @time_format = "%b %e %H:%M:%S"
      
      if output.is_a?(String)
        @io = File.open(output.as(String), mode: "a")
        @on_reopen = -> { @io = File.open(output.as(String), mode: "a"); nil }
      elsif output.responds_to?(:write)
        @io = output
        @on_reopen = -> { }
      else
        raise "Invalid output: #{output.inspect}"
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
      a = [time.to_s(@time_format), " ", tag, ":"]
      map.each do |k, v|
        a << " #{k}="
        a << v.to_json
      end
      post_text a.join
    end
  end
end
