require_relative 'test_helper.rb'

require_relative 'fixtures/mock_client'

class MockClientTest < Minitest::Test
  def test_mock_client_has_headers
    mock = MockClient.new

    expected = [
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

    assert_equal expected, mock.headers
  end

  def test_mock_client_reads_out
    mock = MockClient.new
    expected = [
      'Cache-Control: no-cache',
      'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
      'Postman-Token: 74b2f6f9-d389-f2b4-83c4-c2c9e3569713',
      'Accept: */*',
      'DNT: 1',
      'Accept-Encoding: gzip, deflate, br',
      'Accept-Language: en-US,en;q=0.9'
    ]

    assert_equal 'GET /example HTTP/1.1', mock.gets
    assert_equal 'Host: localhost:9292', mock.gets
    assert_equal 'Connection: keep-alive', mock.gets
    assert_equal expected, mock.read_out
  end

  def test_mock_client_does_post
    mock = MockClient.new :POST
    assert_equal 'POST /example HTTP/1.1', mock.gets
  end

  def test_mock_client_takes_query_string
    mock = MockClient.new :GET, '?foo=bar'
    assert_equal 'GET /example?foo=bar HTTP/1.1', mock.gets
  end

  def test_does_read_partial
    mock = MockClient.new
    assert_equal 'GET /example', mock.readpartial(11)
  end

  def test_can_change_content_type
    mock = MockClient.new :POST
    expected = [
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
      'Content-Length: 15',
      'Content-Type: application/x-www-form-urlencoded'
    ]

    assert_equal expected, mock.alter_content_type('application/json')
    expected[-1] = 'Content-Type: application/json'
    assert_equal expected, mock.alter_content_type('application/json')
  end
end