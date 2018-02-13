require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_open_router
    runner = Runner.new
    assert_instance_of Router, runner.router
    runner.stop
  end
end