require_relative 'test_helper.rb'

require './lib/routers/_router.rb'

class RouterClassTest < Minitest::Test
  def test_does_create_router
    router = Router.new

    assert_instance_of Router, router
  end
end