require_relative '../body_builder'
require_relative '../response_builder'

# Defines client response data
class Response

  def initialize(client, headers)
    @client = client
    @raw_headers = headers
    @status = 200
    @builder = ResponseBuilder.new
  end

  def send(data)
    body = data
    unless @builder.headers['Content-Type'].include?('application/')
      body = response_body(data) if data
    end

    @client.puts @builder.header_string(body)
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
    @status = code
    @builder.status code
  end

  def redirect(location, code = 302)
    @builder.set_header 'Location', location
    @builder.status code
    send nil
  end
end
