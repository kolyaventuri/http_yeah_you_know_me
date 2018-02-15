require_relative 'test_helper.rb'

require './lib/routers/generic_router.rb'
require './test/fixtures/mock_client'
require './lib/client/request'
require './lib/client/response'
require './lib/client_parser'

class RouterClassTest < Minitest::Test
  def setup
    @router = GenericRouter.new(:GET)
  end

  def test_does_create_router
    assert_instance_of GenericRouter, @router
    assert_equal :GET, @router.method
  end

  def test_does_accept_different_methods
    router = GenericRouter.new(:POST)

    assert_instance_of GenericRouter, router
    assert_equal :POST, router.method
  end

  def test_does_take_endpoints
    route = @router.set '/example' do
    end

    assert_instance_of Proc, route

    assert_equal true, @router.set?('/example')
  end

  def test_can_execute_route
    @router.set '/example' do |req|
      req
    end

    client = MockClient.new
    client_info = ClientParser.new(client).data
    router_result = @router.execute(client_info)

    assert_instance_of Request, router_result
    assert_equal '/example', router_result.path
  end

  def test_can_execute_route_with_error_code
    router = GenericRouter.new :ERROR

    router.set 404 do |_req, res|
      res
    end

    client = MockClient.new
    client_info = ClientParser.new(client).data
    router_result = router.execute client_info, 404

    assert_instance_of Response, router_result
    assert_equal 'HTTP/1.1 404 Not Found', router_result.headers.keys[0]
  end
end
