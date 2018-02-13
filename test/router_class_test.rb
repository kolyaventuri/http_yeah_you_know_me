require_relative 'test_helper.rb'

require './lib/routers/_router.rb'

class RouterClassTest < Minitest::Test
  def test_does_create_router
    router = Router.new(:GET)

    assert_instance_of Router, router
    assert_equal :GET, router.method
  end

  
end