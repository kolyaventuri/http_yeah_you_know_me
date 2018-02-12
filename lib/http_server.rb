require 'socket'
require_relative 'response_builder'

# HTTPServer provider
class HTTPServer
  attr_reader :server

  def initialize(port = 9292)
    @server = TCPServer.new port
    @times = 0
    @builder = ResponseBuilder.new
  end

  def start
    client = @server.accept
    output = "<http><body><p>Hello, World! #{@times}</p></body></http>"
    headers = @builder.headers(output)
    client.gets

    client.puts headers
    client.puts output
    client.close
  end

  def close
    @server.close
  end
end
