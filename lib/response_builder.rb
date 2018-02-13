# Creates valid HTTP responses
class ResponseBuilder
  def initialize
    @headers = {
      status: 'HTTP/1.1 200 OK',
      'Date' => nil,
      'Server' => 'ruby',
      'Content-Type' => 'text/html; charset=iso-8859-1',
      'Content-Length' => nil
    }
  end

  def status(code)
    response_code = response_codes[code]
    throw ArgumentError.new if response_code.nil?
    @headers[:status] = "HTTP/1.1 #{code} #{response_code}"
  end

  def set_header(name, value)
    @headers[name] = value
  end

  def headers(output)
    set_header('Content-Length', output.length.to_s)
    @headers['Date'] = Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    headers_array.join("\r\n")
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
