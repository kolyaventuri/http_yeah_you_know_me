require_relative 'test_helper.rb'

require './lib/client/request.rb'
require_relative 'fixtures/mock_client'

class RequestTest < Minitest::Test
  def setup
    @client = MockClient.new
    @request = Request.new @client
  end

  def test_does_create_request_object
    assert_instance_of Request, @request
  end

  def test_does_parse_client
    @request.parse_client

    assert_equal :GET, @request.method
    assert_equal '/example', @request.endpoint
    assert_equal 'keep-alive', @request.headers['Connection']
  end

  def test_does_get_raw_headers
    assert_equal @client.headers, @request.raw_headers
  end

  def test_does_determine_method_and_path
    expected = { method: :GET, path: '/example' }
    assert_equal expected, @request.determine_endpoint(@request.raw_headers[0])
    assert_equal :GET, @request.method
    assert_equal '/example', @request.path
  end

  def test_can_determine_get_post_nil
    get = { method: :GET, path: '/example' }
    post = { method: :POST, path: '/example' }
    bad = { method: nil, path: nil }

    assert_equal get, @request.determine_endpoint('GET /example HTTP/1.1')
    assert_equal post, @request.determine_endpoint('POST /example HTTP/1.1')
    assert_equal bad, @request.determine_endpoint('DELETE /example HTTP/1.1')
  end

  def test_can_get_endpoint
    get = { method: :GET, path: '/example' }
    post = { method: :POST, path: '/example' }
    assert_equal get, @request.get_endpoint_info('GET /example HTTP/1.1')
    assert_equal post, @request.post_endpoint_info('POST /example HTTP/1.1')
  end

  def test_does_return_raw_headers
    assert_equal @client.headers, @request.raw_headers
  end

  def test_does_read_request_headers
    client = MockClient.new :POST
    request = Request.new client

    assert_equal client.headers, request.read_request_headers(client.content)
  end

  def test_does_read_request_body
    client = MockClient.new :POST
    request = Request.new client
    content_without_headers = [''].concat client.body
    assert_equal client.body, request.read_body(content_without_headers)
  end

  def test_does_parse_request_body
    client = MockClient.new :POST
    request = Request.new client
    content_without_headers = [''].concat client.body
    body = request.read_body(content_without_headers)
    expected = { 'foo' => 'bar', 'bar' => 'foo' }
    assert_equal expected, request.parse_body(body)
  end

  def test_does_parse_empty_request_body
    client = MockClient.new :POST
    request = Request.new client
    body = []
    expected = {}
    assert_equal expected, request.parse_body(body)
  end
end
