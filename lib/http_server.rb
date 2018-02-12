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
        determine_endpoint client
        client.puts headers
        client.puts body
        client.close
      end
    end
  end

  def determine_endpoint(endpoint)
    result = { method: nil, endpoint: nil }
    if endpoint.slice(0, 3) == 'GET'
      result[:method] = 'GET'
      endpoint.slice!(0, 4)
      endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
      result[:endpoint] = endpoint
    elsif endpoint.slice(0, 4) == 'POST'
      result[:method] = 'POST'
      endpoint.slice!(0, 5)
      endpoint.slice!(endpoint.length - 9, endpoint.length - 1)
      result[:endpoint] = endpoint
    end
    result
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
    while (line = client.gets) && !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end

  def close
    @server.close
  end
end
