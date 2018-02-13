require_relative 'test_helper.rb'

require './lib/routers/generic_router.rb'
require './test/fixtures/mock_client'
require './lib/client/request'

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
    router_result = @router.execute(client)

    assert_instance_of Request, router_result
    assert_equal '/example', router_result.path
  end
end
