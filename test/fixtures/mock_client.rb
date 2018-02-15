# Defines headers for client unit testing
class MockClient
  attr_reader :read_out, :output
  attr_accessor :method

  def initialize(method = :GET, query_string = '')
    @method = method
    @query_string = query_string
    @read_out = content
    @output = ''
  end

  def gets
    @read_out.shift
  end

  def puts(data)
    @output += data
  end

  def close
    @output
  end

  def headers
    return get_headers if @method == :GET
    return post_headers if @method == :POST
    nil
  end

  def readpartial(length)
    data = @read_out.join("\n")
    data[0..length]
  end

  def get_headers
    [
      "GET /example#{@query_string} HTTP/1.1",
      'Host: localhost:9292',
      'Connection: keep-alive',
      'Cache-Control: no-cache',
      'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
      'Postman-Token: 74b2f6f9-d389-f2b4-83c4-c2c9e3569713',
      'Accept: */*',
      'DNT: 1',
      'Accept-Encoding: gzip, deflate, br',
      'Accept-Language: en-US,en;q=0.9'
    ]
  end

  def post_headers
    [
      "POST /example#{@query_string} HTTP/1.1",
      'Host: localhost:9292',
      'Connection: keep-alive',
      'Cache-Control: no-cache',
      'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
      'Postman-Token: 74b2f6f9-d389-f2b4-83c4-c2c9e3569713',
      'Accept: */*',
      'DNT: 1',
      'Accept-Encoding: gzip, deflate, br',
      'Accept-Language: en-US,en;q=0.9',
      "Content-Length: #{body.join("\n").length}",
      'Content-Type: application/x-www-form-urlencoded'
    ]
  end

  def body
    ['foo=bar&bar=foo']
  end

  def content
    data = headers
    return data if @method == :GET
    data.push ''
    data.concat body
  end

  def alter_content_type(type)
    @read_out[-3] = "Content-Type: #{type}"
  end
end
