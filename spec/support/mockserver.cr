require "socket"
require "uri"
require "msgpack"

class MockServer
  
  @wait = 0.3
  @channel = Channel(Array(MessagePack::Type)).new
  @server : TCPServer | UNIXServer
  
  def initialize(@raw_url : String)
    @url = URI.parse raw_url
    if @url.scheme == "unix"
      @server = UNIXServer.new @raw_url.to_s.sub(/^unix:\/\//, "")
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
    return @url.path if @raw_url.nil?
    @raw_url
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
        socket = if @server.is_a?(UNIXServer)
          @server.as(UNIXServer).accept?
          
        elsif @server.is_a?(TCPServer)
          @server.as(TCPServer).accept?
        end
        message = socket.as(Socket).gets.as(String).to_slice
        @channel.send(Array(MessagePack::Type).from_msgpack(message))
      end
    end
  end
  
  def socket_startup
  end
  
  def shutdown
    @server.close
  end
end