require 'socket'
require_relative 'response_builder'
require_relative 'body_builder'

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
        builder = ResponseBuilder.new
        body_builder = BodyBuilder.new
        request_headers = request_lines client
        output = "Hello, World! (#{@times += 1})"
        body = body_builder.body(output, request_headers)
        headers = builder.headers(body)

        client.puts headers
        client.puts body
        client.close
      end
    end
  end

  def request_lines(client)
    request_lines = []
    while (line = client.gets) and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def close
    @server.close
  end
end
