require "socket"
require "uri"
require "msgpack"

class MockServer
  
  @wait = 0.3
  @queue = [] of Hash(String, String)
  
  #SOCKET_PATH = "/tmp/dummy_fluent.sock"
  
  def initialize(raw_url : String)
    url = URI.parse raw_url
    if url.scheme == "unix"
      raise "not implementation"
    else
      @server = TCPServer.new url.host.as(String), url.port.as(Int32)
    end
  end
  
  def wait_transfer
    sleep @wait
  end

  def port

  end
  
  def socket_path
  end
    
  def run
    @server.accept do |socket|
      message = socket.gets.as(String).to_slice
      return Array(String | Hash(String, String) | UInt32).from_msgpack(message)
    end
  end
  
  def queue
    #puts @channel.receive?
    que = @queue.dup
    @queue.clear
    return que
  end
  
  def startup
  end
  
  def socket_startup
  end
  
  def shutdown
  end
end