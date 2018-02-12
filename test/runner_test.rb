require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_run_server
    skip
    runner = Runner.new
    runner.start
  end
end