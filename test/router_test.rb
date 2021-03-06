require_relative 'test_helper.rb'
require 'pry'

require_relative 'fixtures/mock_client'
require './lib/client/request'
require './lib/client/response'
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
    resulting_request = router.execute client

    assert_instance_of Request, resulting_request
    assert_equal '/example', resulting_request.path
  end

  def test_router_has_default_error_handler
    router = Router.new

    assert_equal true, router.set?(:ERROR, 404)
  end

  def test_router_can_set_different_error_handler
    router = Router.new
    handler = proc {}

    assert_equal handler, router.on(404, &handler)
    assert_equal true, router.set?(:ERROR, 404)
  end

  def test_router_can_take_post_endpoints
    router = Router.new
    get_route = router.post '/example' do |req, _res|
      req
    end
    assert_instance_of Proc, get_route

    assert_equal false, router.set?(:GET, '/example')
    assert_equal true, router.set?(:POST, '/example')

    client = MockClient.new :POST

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

  def test_router_handles_404
    router = Router.new

    client = MockClient.new
    resulting_request = router.execute client

    assert_instance_of Response, resulting_request
    assert_equal true, client.output.include?('HTTP/1.1 404 Not Found')
  end

  def test_router_handes_405
    router = Router.new
    client = MockClient.new :DELETE
    resulting_request = router.execute client

    assert_instance_of Response, resulting_request
    assert_equal true, client.output.include?('HTTP/1.1 405 Method Not Allowed')
  end
end
