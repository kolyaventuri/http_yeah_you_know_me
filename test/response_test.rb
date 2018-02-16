require_relative 'test_helper.rb'

require 'json'
require './lib/client/response'
require './lib/client/request'
require_relative 'fixtures/mock_client'

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

  def test_can_set_arbitrary_header
    @response.set_header 'X-Foo', 'Bar'
    @response.send('1,2,3,4')
    expected_w_headers = ['HTTP/1.1 200 OK',
                          "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                          'Server: ruby',
                          'Content-Type: text/html; charset=iso-8859-1',
                          'Content-Length: 382',
                          "X-Foo: Bar\r\n\r\n"].join("\r\n")
    expected_w_headers += @expected
    assert_equal expected_w_headers, @client.output
  end

  def test_can_change_status
    @response.status 404
    @response.send('1,2,3,4')
    expected_w_headers = ['HTTP/1.1 404 Not Found',
                          "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                          'Server: ruby',
                          'Content-Type: text/html; charset=iso-8859-1',
                          "Content-Length: 382\r\n\r\n"].join("\r\n")
    expected_w_headers += @expected
    assert_equal expected_w_headers, @client.output
  end

  def test_can_set_redirect
    @response.redirect 'http://google.com'
    expected = ['HTTP/1.1 302 Found',
                          "Location: http://google.com\r\n\r\n"].join("\r\n")
    assert_equal expected, @client.output
  end

  def test_can_set_redirect_with_code
    @response.redirect 'http://google.com', 301
    expected = ['HTTP/1.1 301 Moved Permanently',
                          "Location: http://google.com\r\n\r\n"].join("\r\n")
    assert_equal expected, @client.output
  end

  def test_can_respond_with_proper_json
    @response.set_header 'Content-Type', 'application/json'
    output = { hello: 'test' }
    json = output.to_json
    expected = ['HTTP/1.1 200 OK',
                "Date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                'Server: ruby',
                'Content-Type: application/json',
                "Content-Length: #{json.length} \r\n\r\n"].join("\r\n")
    expected += json

    @response.send json

    assert_equal expected, @client.output
  end
end