# Defines headers for client unit testing
class MockClient
  attr_reader :read_out

  def initialize
    @read_out = headers
  end

  def gets
    @read_out.shift
  end

  def headers
    [
      'GET /example HTTP/1.1',
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
end
