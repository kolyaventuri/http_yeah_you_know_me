require 'socket'

# HTTPServer provider
class HTTPServer
  attr_reader :server

  def initialize(port = 9292)
    @server = TCPServer.new port
    @times = 0
  end

  def start
    @client = @server.accept
  end

  def close
    @client.close
  end
end
