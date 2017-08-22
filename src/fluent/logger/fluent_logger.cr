#require "msgpack"
require "./logger_base"
require "socket"

module Fluent::Logger
  class EventTime
    TYPE = 0

    def initialize(@time)
    end

    def to_msgpack(io = nil)
      @time.to_i.to_msgpack io
    end

    def to_msgpack_ext
      [@time.to_i, @time.nsec].pack("NN")
    end

    def self.from_msgpack_ext(data)
      new(*data.unpack "NN")
    end

    def to_json(*args)
      @time.to_i
    end
  end

  class FluentLogger < LoggerBase
    BUFFER_LIMIT = 8*1024*1024
    #RECONNECT_WAIT = 0.5
    #RECONNECT_WAIT_INCR_RATE = 1.5
    #RECONNECT_WAIT_MAX = 60

    private getter conn : Socket | Nil

    def initialize(
        @tag_prefix : String | Nil = nil,
        @host = "localhost",
        @port = 24224,
        @socket_path : String | Nil = nil,
        @limit : Int32 = BUFFER_LIMIT
      )
      @time_format = "%b %e %H:%M:%S"

    end

    def post_with_time(tag, map, time)
      tag = "#{@tag_prefix}.#{tag}" if @tag_prefix
      write [tag, time.to_i, map]
    end

    def write(msg)
      begin
        data = to_msgpack msg
        send_data data
        true
      rescue e
        @conn.close if connect?
        @conn = nil
        false
      end
    end

    def send_data(data)
      unless connect?
        connect!
      end
      @conn.write data
      true
    end

    def create_socket!
      @conn = if @socket_path
        UNIXSocket.new(@socket_path)
      else
        TCPSocket.new(@host, @port)
      end
    end

    def connect!
      create_socket!
      @conn.sync = true
    rescue e
      raise e
    end
  end
end
