require_relative 'test_helper.rb'

require './lib/client/response'
require './lib/client/request'
require './lib/mock_client'

class ResponseTest < Minitest::Test
  def setup
    @client = MockClient.new
    @response = Response.new @client, @client.headers
    @expected = "1,2,3,4\n<pre>\nGET /example HTTP/1.1\nHost: localhost:9292\nConnection: keep-alive\nCache-Control: no-cache\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36\nPostman-Token: 74b2f6f9-d389-f2b4-83c4-c2c9e3569713\nAccept: */*\nDNT: 1\nAccept-Encoding: gzip, deflate, br\nAccept-Language: en-US,en;q=0.9\n</pre>"
  end

  def test_can_create_response
    assert_instance_of Response, @response
  end

  def test_can_build_response_body
    assert_equal @expected, @response.response_body('1,2,3,4')
  end

  def test_can_send_data
    @response.send('1,2,3,4')
    expected_w_headers = ['HTTP/1.1 200 OK',
                          "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                          'Server: ruby',
                          'Content-Type: text/html; charset=iso-8859-1',
                          "Content-Length: 382\r\n\r\n"].join("\r\n")
    expected_w_headers += @expected
    assert_equal expected_w_headers, @client.output
  end
end