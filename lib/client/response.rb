require_relative '../body_builder'
require_relative '../response_builder'

# Defines client response data
class Response
  attr_reader :headers

  def initialize(client, headers)
    @client = client
    @headers = {}
    @raw_headers = headers
    @builder = ResponseBuilder.new
  end

  def send(data)
    body = response_body(data) if data
    @client.puts @builder.headers(body)
    @client.puts body if data
    @client.close
  end

  def response_body(output)
    body_builder = BodyBuilder.new
    body_builder.body(output, @raw_headers)
  end

  def set_header(name, value)
    @builder.set_header name, value
  end

  def status(code)
    @builder.status code
  end

  def redirect(location, code = 302)
    @builder.set_header 'Location', location
    @builder.status code
    send nil
  end
end
