require 'faraday'
require_relative 'test_helper.rb'

require './lib/runner.rb'

class RunnerTest < Minitest::Test
  def test_does_open_router
    runner = Runner.new 8000
    assert_instance_of Router, runner.router
    Thread.new do
      runner.start

    end
    runner.stop
  end

  def test_does_have_endpoints
    Thread.new do
      fork do
        # :nocov:
        # We're only ignoring this because simplecov just can't see it.
        # Test's don't run without it though, so it still technically runs.
        system 'ruby ./lib/server/runner.rb'
        # :nocov:
      end
    end
    sleep 4
    conn = Faraday.new url: 'http://localhost:9292'

    assert conn.get('/').body

    assert_equal true, conn.get('/hello').body.include?('Hello, world! (1)')
    assert_equal true, conn.get('/hello').body.include?('Hello, world! (2)')
    assert_equal true, conn.get('/hello').body.include?('Hello, world! (3)')

    now = Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
    assert_equal true, conn.get('/datetime').body.include?(now)

    assert_equal true, conn.get('/word_search?word=asdaksjdhas').body.include?('asdaksjdhas is not a known word')
    assert_equal true, conn.get('/word_search?word=toast').body.include?('toast is a known word')

    assert_equal true, conn.post('/start_game').body.include?('Good luck!')
    request = conn.post '/start_game'
    assert_equal true, request.body.include?('Game is already running')
    assert_equal 403, request.status

    request = conn.post '/game', guess: 50
    assert_equal 302, request.status

    assert_equal true, conn.get('/game').body.include?('1 guesses have been taken')

    assert_equal 404, conn.get('/foobar').status

    assert_equal 500, conn.get('/force_error').status

    assert_equal true, conn.get('/shutdown').body.include?('Total Requests: ')
  end
end