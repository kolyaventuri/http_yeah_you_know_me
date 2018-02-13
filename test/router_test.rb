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

    assert_equal true, router.set?('GET', '/example')
    assert_equal false, router.set?('POST', '/example')

    client = MockClient.new

    resulting_request = router.execute(client)

    assert_instance_of Request, resulting_request
    assert_equal '/example', resulting_request.path
  end
end
