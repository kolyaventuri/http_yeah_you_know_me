require_relative 'test_helper.rb'
require 'faraday'

require './lib/http_server.rb'

class HTTPServerTest < Minitest::Test
  def setup
    @conn = Faraday.new(url: 'http://localhost:9292')
  end

  def test_does_create_server
    server = HTTPServer.new
    server.start
    assert_instance_of TCPServer, server.server

    server.start
  end

  def test_does_respond_correctly
    server = HTTPServer.new
    server.start
    assert_equal 'Hello World (0)', conn.get('/')
    server.close
  end

  def test_does_server_increment_count
    server = HTTPServer.new
    server.start
    assert_equal 'Hello World (0)', conn.get('/')
    assert_equal 'Hello World (1)', conn.get('/')
    server.close
  end
end
