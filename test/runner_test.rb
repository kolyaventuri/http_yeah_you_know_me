require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_open_router
    runner = Runner.new
    assert_instance_of Router, runner.router
  end

  def test_does_run_server
    runner = Runner.new
    router = runner.router
    times = 0
    router.get '/hello', (proc do |_req, res|
      res.send "Hello, world! (#{times += 1})"
    end)
    runner.start
  end
end