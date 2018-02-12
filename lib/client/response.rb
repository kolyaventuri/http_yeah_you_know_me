require_relative '../body_builder'
require_relative '../response_builder'

# Defines client response data
class Response
  def initialize(client, headers)
    @client = client
    @headers = {}
    @raw_headers = headers
    @builder = ResponseBuilder.new
  end

  def send(data)
    @client.puts @builder.headers(data)
    @client.puts response_body(data)
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
end