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
        body = response_body("Hello, World! (#{@times += 1})", client)
        headers = response_headers(body)

        client.puts headers
        client.puts body
        client.close
      end
    end
  end

  def response_body(output, client)
    request_headers = request_lines client
    body_builder = BodyBuilder.new
    body_builder.body(output, request_headers)
  end

  def response_headers(body)
    builder = ResponseBuilder.new
    builder.headers(body)
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
