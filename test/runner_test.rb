require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_open_router
    runner = Runner.new
    assert_instance_of Router, runner.router
  end

  def test_does_run_server
    runner = Runner.new
    runner.start
  end
end