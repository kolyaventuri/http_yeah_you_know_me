require_relative 'test_helper.rb'
require 'pry'

require './lib/router.rb'

class RouterTest < Minitest::Test

  def test_router_can_take_get_endpoints
    router = Router.new
    get_route = router.get '/dummy', (proc do |arg|
      arg
    end)
    assert_instance_of Proc, get_route

    assert_equal true, router.get_set?('/dummy')
    assert_equal false, router.set?('POST', '/dummy')
    assert_equal true, router.set?('GET', '/dummy')

    assert_equal ['Hello', 'world'], router.execute('GET', '/dummy', ['Hello', 'world'])
  end

  def test_router_can_take_post_endpoints
    router = Router.new
    post_route = router.post '/dummy', (proc do |arg|
      arg
    end)
    assert_instance_of Proc, post_route

    assert_equal true, router.post_set?('/dummy')
    assert_equal false, router.set?('GET', '/dummy')
    assert_equal true, router.set?('POST', '/dummy')

    assert_equal ['Hello', 'world'], router.execute('POST', '/dummy', ['Hello', 'world'])
  end

end