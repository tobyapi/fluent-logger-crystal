require "socket"
require "uri"
require "msgpack"

class MockServer
  
  @wait = 0.3
  @channel = Channel(Array(MessagePack::Type)).new
    
  def initialize(raw_url : String)
    @url = URI.parse raw_url
    if @url.scheme == "unix"
      raise "not implementation"
    else
      @server = TCPServer.new @url.host.as(String), @url.port.as(Int32)
    end
  end
  
  def wait_transfer
    sleep @wait
  end

  def port
    @url.port.as(Int32)
  end
  
  def socket_path
    @url.path
  end
      
  def queue
    que = [] of Array(MessagePack::Type)
    while data = @channel.receive
      que << data
    end
    return que
  end
  
  def startup
    spawn do
      loop do
        @server.accept do |socket|
          message = socket.gets.as(String).to_slice
          @channel.send(Array(MessagePack::Type).from_msgpack(message))
        end
      end
    end
  end
  
  def socket_startup
  end
  
  def shutdown
  end
end