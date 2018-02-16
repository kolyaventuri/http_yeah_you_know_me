require_relative 'test_helper.rb'
require 'faraday'

require './lib/http_server.rb'

class HTTPServerTest < Minitest::Test
  def test_does_create_server
    server = HTTPServer.new
    assert_instance_of TCPServer, server.server
    server.router.get '/' do |_req, res|
      res.send 'Hi'
      server.close
    end
    Thread.new do
      server.start
    end
    assert_equal true, server.open?

    conn = Faraday.new url: 'http://localhost:9292'
    response = conn.get '/'
    assert_equal true, response.body.include?('Hi')
  end
end
