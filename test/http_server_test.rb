require_relative 'test_helper.rb'
require 'faraday'

require './lib/http_server.rb'

class HTTPServerTest < Minitest::Test
  SERVER = HTTPServer.new

  def test_does_create_server
    assert_instance_of TCPServer, SERVER.server
  end
end
