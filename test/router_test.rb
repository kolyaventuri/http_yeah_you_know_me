require_relative 'test_helper.rb'
require 'pry'

require './lib/mock_client'
require './lib/client/request'
require './lib/router.rb'

class RouterTest < Minitest::Test

  def test_router_can_take_get_endpoints
    router = Router.new
    get_route = router.get '/example', (proc do |req, _res|
      req
    end)
    assert_instance_of Proc, get_route

    assert_equal true, router.get_set?('/example')
    assert_equal false, router.set?('POST', '/example')
    assert_equal true, router.set?('GET', '/example')

    client = MockClient.new

    resulting_request = router.execute(client)

    assert_instance_of Request, resulting_request
    assert_equal '/example', resulting_request.path
  end

  def test_router_can_take_post_endpoints
    router = Router.new
    post_route = router.post '/example', (proc do |arg|
      arg
    end)
    assert_instance_of Proc, post_route

    assert_equal true, router.post_set?('/example')
    assert_equal false, router.set?('GET', '/example')
    assert_equal true, router.set?('POST', '/example')

    client = MockClient.new :POST
    
    resulting_request = router.execute(client)

    assert_instance_of Request, resulting_request
    assert_equal '/example', resulting_request.path
  end
end
