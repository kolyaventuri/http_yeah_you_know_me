require_relative 'test_helper.rb'
require 'pry'

require_relative 'fixtures/mock_client'
require './lib/client/request'
require './lib/router.rb'

class RouterTest < Minitest::Test

  def test_router_can_take_get_endpoints
    router = Router.new
    get_route = router.get '/example' do |req, _res|
      req
    end
    assert_instance_of Proc, get_route

    assert_equal true, router.set?(:GET, '/example')
    assert_equal false, router.set?(:POST, '/example')

    client = MockClient.new

    resulting_request = router.execute(client)

    assert_instance_of Request, resulting_request
    assert_equal '/example', resulting_request.path
  end

  def test_router_can_take_get_parameters
    router = Router.new
    router.get '/example' do |req, _res|
      req
    end

    client = MockClient.new(:GET, '?foo=bar&bar=foo')

    resulting_request = router.execute(client)

    expected = { 'foo' => 'bar', 'bar' => 'foo' }

    assert_instance_of Request, resulting_request
    assert_equal '/example?foo=bar&bar=foo', resulting_request.path
    assert_equal expected, resulting_request.params
  end
end
