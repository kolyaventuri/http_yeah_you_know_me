require 'faraday'
require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_open_router
    runner = Runner.new
    assert_instance_of Router, runner.router
    runner.stop
  end

  def test_does_have_endpoints

    conn = Faraday.new url: 'http://localhost:9292'

    assert conn.get('/').body

    assert_equal true, conn.get('/hello').body.include?('Hello, world! (1)')
    assert_equal true, conn.get('/hello').body.include?('Hello, world! (2)')
    assert_equal true, conn.get('/hello').body.include?('Hello, world! (3)')

    now = Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
    assert_equal true, conn.get('/datetime').body.include?(now)

    assert_equal true, conn.get('/word_search?word=asdaksjdhas').body.include?('asdaksjdhas is not a known word')
    assert_equal true, conn.get('/word_search?word=toast').body.include?('toast is a known word')

    assert_equal true, conn.get('/shutdown').body.include?('Total Requests: 8')
  end
end