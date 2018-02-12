require_relative 'test_helper.rb'
require 'faraday'

require './lib/http_server.rb'

class HTTPServerTest < Minitest::Test
  SERVER = HTTPServer.new

  def test_does_create_server
    assert_instance_of TCPServer, SERVER.server
    SERVER.close
  end

  def test_does_determine_endpoint
    expected_get = { method: 'GET', endpoint: '/test' }
    expected_post = { method: 'POST', endpoint: '/test' }
    expected_nil = { method: nil, endpoint: nil }
    assert_equal expected_get, SERVER.determine_endpoint('GET /test HTTP/1.1')
    assert_equal expected_post, SERVER.determine_endpoint('POST /test HTTP/1.1')
    assert_equal expected_nil, SERVER.determine_endpoint('DELETE /test HTTP/1.1')
  end
end
