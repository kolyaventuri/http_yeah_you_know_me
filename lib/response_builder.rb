# Creates valid HTTP responses
class ResponseBuilder
  def initialize
    @headers = {
      status: 'http/1.1 200 OK',
      'date' => nil,
      'server' => 'ruby',
      'content-type' => 'text/html; charset=iso-8859-1',
      'content-length' => nil
    }
  end

  def status(code)
    response_code = response_codes code
    throw ArgumentError.new if response_code.nil?
    @headers[:status] = "http/1.1 #{response_code}"
  end

  def set_header(name, value)
    @headers[name] = value
  end

  def headers(output)
    set_header('content-length', output.length.to_s)
    @headers['date'] = Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    headers_array.join('\r\n')
  end

  def headers_array
    head_array = @headers.map do |key, value|
      if key.instance_of?(Symbol)
        value
      else
        "#{key}: #{value}"
      end
    end
    head_array[-1] += "\r\n\r\n"
    head_array
  end

  def response_codes
    {
      200 => '200 OK',
      301 => 'Moved Permanently',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not Found',
      500 => 'Internal Server Error'
    }
  end
end
