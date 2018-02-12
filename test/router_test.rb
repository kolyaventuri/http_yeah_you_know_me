require_relative 'test_helper.rb'

require './lib/router.rb'

class RouterTest < Minitest::Test

  def test_router_can_take_get_endpoints
    router = Router.new
    get_route = router.get '/dummy', dummy_get_handler
    assert get_route

    assert router.get_set?('/dummy')
  end

  def dummy_get_handler
    puts 'Hi'
  end

end