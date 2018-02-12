require_relative 'test_helper.rb'
require 'faraday'

require './lib/http_server.rb'

class HTTPServerTest < Minitest::Test

  def test_does_create_server
    server = HTTPServer.new
    assert_instance_of TCPServer, server.server
    assert_equal true, server.open?
    server.close
    assert_equal false, server.open?
  end
end
