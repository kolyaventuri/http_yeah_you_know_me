require './lib/runner'
require './lib/dictionary/complete_me'
require 'pry'

dictionary = CompleteMe.new
words = File.read('/usr/share/dict/words')
dictionary.populate(words)

runner = Runner.new
router = runner.router
hello_times = 0
request_count = 0

game_running = false
RIGHT_GUESS = 0
guesses = []

router.get '*' do
  request_count += 1
end

router.post '*' do
  request_count += 1
end

router.get '/' do |_req, res|
  res.send ''
end

router.get '/hello' do |_req, res|
  res.send "Hello, world! (#{hello_times += 1})"
end

router.get '/datetime' do |_req, res|
  res.send Time.now.strftime('%l:%M%p on %A, %B %e, %Y')
end

router.get '/shutdown' do |_req, res|
  res.send "Total Requests: #{request_count}"
  runner.server.close
end

router.get '/word_search' do |req, res|
  word = req.params['word']
  return res.send 'No word supplied' if word.nil?
  options = dictionary.suggest word
  if options.include? word
    res.send "#{word} is a known word"
  else
    res.send "#{word} is not a known word"
  end
end

router.post '/start_game' do |_req, res|
  if game_running
    res.status 403
    res.send 'Game is already running'
  else
    game_running = true
    RIGHT_GUESS = (0..100).to_a.sample
    res.send 'Good luck!'
  end
end

router.get '/game' do |_req, res|
  out = "#{guesses.length} guesses have been taken."
  unless guesses.last.nil?
    out += "\n\n"
    out += "Your most recent guess, #{guesses.last}, was #{check_guess(guesses.last)}"
  end
  res.send out
end

router.post '/game' do |req, res|
  guess = req.body['guess'].to_i
  guesses.push guess
  res.redirect '/game'
end

router.get '/force_error' do |_req, res|
  res.status 500
  begin
    Math.sqrt(-1)
  rescue => e
    out = "An error was encountered. Stack trace below<br /><br />"
    out += e.backtrace.join("\n")
    res.send out
  end
end

def check_guess(guess)
  return 'too low.' if guess < RIGHT_GUESS
  return 'too high.' if guess > RIGHT_GUESS
  'correct!'
end

runner.start
