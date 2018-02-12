require 'socket'
require_relative 'response_builder'

# HTTPServer provider
class HTTPServer
  attr_reader :server

  def initialize(port = 9292)
    @server = TCPServer.new port
    @times = 0
  end

  def start
    loop do
      Thread.new(@server.accept) do |client|
        output = "Hello, World! (#{@times += 1})"
        builder = ResponseBuilder.new
        headers = builder.headers(output)
        client.gets

        client.puts headers
        client.puts output
        client.close
      end
    end
  end

  def close
    @server.close
  end
end
